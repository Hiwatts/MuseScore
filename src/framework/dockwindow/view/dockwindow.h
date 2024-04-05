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

#ifndef MUSE_DOCK_DOCKWINDOW_H
#define MUSE_DOCK_DOCKWINDOW_H

#include <QQuickItem>

#include "framework/uicomponents/view/qmllistproperty.h"

#include "async/asyncable.h"
#include "async/asyncable.h"

#include "modularity/ioc.h"
#include "workspace/iworkspacemanager.h"
#include "ui/iuiconfiguration.h"
#include "idockwindowprovider.h"

#include "idockwindow.h"
#include "internal/dockbase.h"

#ifndef MU_QT5_COMPAT
Q_MOC_INCLUDE(< QQuickWindow >)
#endif

namespace KDDockWidgets {
class MainWindowBase;
class LayoutSaver;
}

namespace muse::dock {
class DockToolBarView;
class DockingHolderView;
class DockPageView;
class DockWindow : public QQuickItem, public IDockWindow, public async::Asyncable
{
    Q_OBJECT

    Q_PROPERTY(QString currentPageUri READ currentPageUri NOTIFY currentPageUriChanged)

    Q_PROPERTY(QQmlListProperty<muse::dock::DockToolBarView> toolBars READ toolBarsProperty)
    Q_PROPERTY(QQmlListProperty<muse::dock::DockPageView> pages READ pagesProperty)

    Q_PROPERTY(QQuickWindow * window READ windowProperty NOTIFY windowPropertyChanged)

    INJECT(mu::ui::IUiConfiguration, uiConfiguration)
    INJECT(muse::workspace::IWorkspaceManager, workspaceManager)
    INJECT(IDockWindowProvider, dockWindowProvider)

public:
    explicit DockWindow(QQuickItem* parent = nullptr);
    ~DockWindow() override;

    QString currentPageUri() const;

    QQmlListProperty<muse::dock::DockToolBarView> toolBarsProperty();
    QQmlListProperty<muse::dock::DockPageView> pagesProperty();

    QQuickWindow* windowProperty() const;

    Q_INVOKABLE void init();
    Q_INVOKABLE void loadPage(const QString& uri, const QVariantMap& params);

    //! IDockWindow
    bool isDockOpen(const QString& dockName) const override;
    void toggleDock(const QString& dockName) override;
    void setDockOpen(const QString& dockName, bool open) override;

    async::Channel<QStringList> docksOpenStatusChanged() const override;

    bool isDockFloating(const QString& dockName) const override;
    void toggleDockFloating(const QString& dockName) override;

    DockPageView* currentPage() const override;
    QQuickItem& asItem() const override;

    void restoreDefaultLayout() override;

signals:
    void pageLoaded();
    void currentPageUriChanged(const QString& uri);
    void windowPropertyChanged(QQuickWindow* window);

private slots:
    void onQuit();

private:
    DockPageView* pageByUri(const QString& uri) const;

    bool doLoadPage(const QString& uri, const QVariantMap& params = {});

    void componentComplete() override;
#ifdef MU_QT5_COMPAT
    void geometryChanged(const QRectF& newGeometry, const QRectF& oldGeometry) override;
#else
    void geometryChange(const QRectF& newGeometry, const QRectF& oldGeometry) override;
#endif

    void loadPageContent(const DockPageView* page);
    void loadToolBars(const DockPageView* page);
    void loadPanels(const DockPageView* page);
    void loadTopLevelToolBars(const DockPageView* page);
    void alignTopLevelToolBars(const DockPageView* page);

    void addDock(DockBase* dock, Location location = Location::Left, const DockBase* relativeTo = nullptr);
    void registerDock(DockBase* dock);

    void saveGeometry();
    void restoreGeometry();

    QByteArray windowState() const;

    void savePageState(const QString& pageName);
    void restorePageState(const QString& pageName);

    void reloadCurrentPage();
    bool restoreLayout(const QByteArray& layout, bool restoreRelativeToMainWindow = false);

    void initDocks(DockPageView* page);

    void notifyAboutDocksOpenStatus();

    QList<DockToolBarView*> topLevelToolBars(const DockPageView* page) const;

    KDDockWidgets::MainWindowBase* m_mainWindow = nullptr;
    DockPageView* m_currentPage = nullptr;
    mu::uicomponents::QmlListProperty<DockToolBarView> m_toolBars;
    mu::uicomponents::QmlListProperty<DockPageView> m_pages;
    async::Channel<QStringList> m_docksOpenStatusChanged;

    bool m_hasGeometryBeenRestored = false;
    bool m_reloadCurrentPageAllowed = false;
};
}

#endif // MUSE_DOCK_DOCKWINDOW_H
