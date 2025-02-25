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

import QtQuick 2.15
import QtQuick.Controls 2.15
import MuseScore.Ui 1.0
import MuseScore.UiComponents 1.0
import MuseScore.Audio 1.0
import MuseScore.Playback 1.0

import "internal"

Rectangle {
    id: root

    property alias navigation: flickable.navigation
    property alias contextMenuModel: flickable.contextMenuModel

    color: ui.theme.backgroundPrimaryColor

    Flickable {
        id: flickable

        property alias navigation: navPanel
        property alias contextMenuModel: contextMenuModel

        function positionViewAtEnd() {
            if (flickable.contentY == flickable.contentHeight) {
                return
            }

            flickable.contentY = flickable.contentHeight - flickable.height
        }

        onContentHeightChanged: {
            flickable.positionViewAtEnd()
        }

        anchors.fill: parent

        clip: true
        boundsBehavior: Flickable.StopAtBounds

        contentWidth: contentColumn.width
        contentHeight: contentColumn.height
        interactive: height < contentHeight || width < contentWidth

        ScrollBar.vertical: StyledScrollBar {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: 8
            policy: ScrollBar.AlwaysOn
            active: true

            //!Note Scrollbars attached to Flickable have their properties (like active) being set by Flickable automatically
            //      So it completely ignores the policy and such other stuff
            //      In order to set our own behaviour we have to common approaches:
            //      - 1 - Explicitly override changes from Flickable in according handlers (current approach)
            //      - 2 - Use non-attached ScrollBars as a child objects to Flickable, but in this case we'll have to re-implement
            //            communication among them from scratch
            onActiveChanged: {
                if (!active) {
                    active = true
                }
            }
        }

        ScrollBar.horizontal: StyledScrollBar {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottomMargin: 8
        }

        NavigationPanel {
            id: navPanel
            name: "MixerPanel"
            enabled: root.enabled && root.visible
        }

        MixerPanelModel {
            id: mixerPanelModel

            Component.onCompleted: {
                mixerPanelModel.load()
            }
        }

        MixerPanelContextMenuModel {
            id: contextMenuModel

            Component.onCompleted: {
                contextMenuModel.load()
            }
        }

        Column {
            id: contentColumn

            width: childrenRect.width

            spacing: 8

            MixerSoundSection {
                id: soundSection

                visible: contextMenuModel.soundSectionVisible
                headerVisible: contextMenuModel.labelsSectionVisible
                rootPanel: root

                model: mixerPanelModel
            }

            MixerFxSection {
                id: fxSection

                visible: contextMenuModel.audioFxSectionVisible
                headerVisible: contextMenuModel.labelsSectionVisible
                rootPanel: root

                model: mixerPanelModel
            }

            MixerBalanceSection {
                id: balanceSection

                visible: contextMenuModel.balanceSectionVisible
                headerVisible: contextMenuModel.labelsSectionVisible
                rootPanel: root

                model: mixerPanelModel
            }

            MixerVolumeSection {
                id: volumeSection

                visible: contextMenuModel.volumeSectionVisible
                headerVisible: contextMenuModel.labelsSectionVisible
                rootPanel: root

                model: mixerPanelModel
            }

            MixerTitleSection {
                id: titleSection

                visible: contextMenuModel.titleSectionVisible
                headerVisible: contextMenuModel.labelsSectionVisible
                rootPanel: root

                model: mixerPanelModel
            }
        }
    }

    onHeightChanged: {
        flickable.positionViewAtEnd()
    }
}
