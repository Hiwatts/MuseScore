/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-Studio-CLA-applies
 *
 * MuseScore Studio
 * Music Composition & Notation
 *
 * Copyright (C) 2025 MuseScore Limited
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

#pragma once

#include "notationtypes.h"

#include "engraving/dom/utils.h"

namespace mu::notation {
inline int noteValToLine(const NoteVal& nval, const Staff* staff, const Fraction& tick)
{
    const bool concertPitch = staff->concertPitch();
    const int pitchOffset = concertPitch ? 0 : staff->part()->instrument(tick)->transpose().chromatic;
    const int epitch = nval.pitch - pitchOffset;

    int tpc = nval.tpc(concertPitch);
    if (tpc == static_cast<int>(mu::engraving::Tpc::TPC_INVALID)) {
        tpc = mu::engraving::pitch2tpc(epitch, staff->key(tick), mu::engraving::Prefer::NEAREST);
    }

    return mu::engraving::relStep(epitch, tpc, staff->clef(tick));
}
}
