/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-CLA-applies
 *
 * MuseScore
 * Music Composition & Notation
 *
 * Copyright (C) 2021 MuseScore BVBA and others
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#include "symboldialog.h"

#include "engraving/style/style.h"

#include "libmscore/masterscore.h"
#include "libmscore/scorefont.h"
#include "libmscore/symnames.h"
#include "libmscore/engravingitem.h"
#include "libmscore/symbol.h"

#include "palettewidget.h"

#include "smuflranges.h"

using namespace mu::palette;

namespace Ms {
extern MasterScore* gpaletteScore;

//---------------------------------------------------------
//   createSymbolPalette
//---------------------------------------------------------

void SymbolDialog::createSymbolPalette()
{
    sp = new PaletteWidget();
    createSymbols();
}

//---------------------------------------------------------
//   createSymbols
//---------------------------------------------------------

void SymbolDialog::createSymbols()
{
    int currentIndex = fontList->currentIndex();
    const ScoreFont* f = &ScoreFont::scoreFonts()[currentIndex];
    // init the font if not done yet
    ScoreFont::fontByName(f->name());
    sp->clear();
    for (auto name : (*mu::smuflRanges())[range]) {
        SymId id = SymNames::symIdByName(name);
        if (search->text().isEmpty()
            || SymNames::translatedUserNameForSymId(id).contains(search->text(), Qt::CaseInsensitive)) {
            auto s = std::make_shared<Symbol>(gpaletteScore->dummy());
            s->setSym(SymId(id), f);
            sp->appendElement(s, SymNames::translatedUserNameForSymId(SymId(id)));
        }
    }
}

//---------------------------------------------------------
//   SymbolDialog
//---------------------------------------------------------

SymbolDialog::SymbolDialog(const QString& s, QWidget* parent)
    : QWidget(parent, Qt::WindowFlags(Qt::Dialog | Qt::Window))
{
    setupUi(this);
    range = s;          // smufl symbol range
    int idx = 0;
    int currentIndex = 0;
    for (const ScoreFont& f : ScoreFont::scoreFonts()) {
        fontList->addItem(f.name());
        if (f.name() == "Leland" || f.name() == "Bravura") {
            currentIndex = idx;
        }
        ++idx;
    }
    fontList->setCurrentIndex(currentIndex);

    QLayout* l = new QVBoxLayout();
    frame->setLayout(l);
    createSymbolPalette();

    QScrollArea* sa = new PaletteScrollArea(sp);
    l->addWidget(sa);

    sp->setAcceptDrops(false);
    sp->setDrawGrid(true);
    sp->setSelectable(true);

    connect(systemFlag, &QCheckBox::stateChanged, this, &SymbolDialog::systemFlagChanged);
    connect(fontList, QOverload<int>::of(&QComboBox::currentIndexChanged), this, &SymbolDialog::systemFontChanged);

    sa->setWidget(sp);
}

//---------------------------------------------------------
//   systemFlagChanged
//---------------------------------------------------------

void SymbolDialog::systemFlagChanged(int state)
{
    bool sysFlag = state == Qt::Checked;
    for (int i = 0; i < sp->actualCellCount(); ++i) {
        ElementPtr e = sp->elementForCellAt(i);
        if (e && e->type() == ElementType::SYMBOL) {
            std::dynamic_pointer_cast<Symbol>(e)->setSystemFlag(sysFlag);
        }
    }
}

//---------------------------------------------------------
//   systemFontChanged
//---------------------------------------------------------

void SymbolDialog::systemFontChanged(int)
{
    createSymbols();
}

void SymbolDialog::on_search_textChanged(const QString& searchPhrase)
{
    Q_UNUSED(searchPhrase);
    createSymbols();
}

void SymbolDialog::on_clearSearch_clicked()
{
    search->clear();
    createSymbols();
}

//---------------------------------------------------------
//   changeEvent
//---------------------------------------------------------

void SymbolDialog::changeEvent(QEvent* event)
{
    QWidget::changeEvent(event);
    if (event->type() == QEvent::LanguageChange) {
        retranslate();
    }
}
}
