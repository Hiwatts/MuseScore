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
import MuseScore.Ui 1.0

FocusScope {
    id: root

    default property alias content: contentItemContaner.data
    property alias contentItem: contentItemContaner
    property alias background: focusRectItem
    property alias focusBorder: focusBorderItem

    property alias mouseArea: mouseAreaItem

    property alias navigation: navCtrl

    signal navigationActived()
    signal navigationTriggered()

    function ensureActiveFocus() {
        if (!root.activeFocus) {
            root.forceActiveFocus()
        }
    }

    NavigationControl {
        id: navCtrl
        name: root.objectName
        enabled: root.enabled && root.visible

        onActiveChanged: {
            if (navCtrl.active) {
                root.ensureActiveFocus()
                root.navigationActived()
            }
        }

        onTriggered: {
            root.navigationTriggered()
        }
    }

    Rectangle {
        id: focusRectItem
        anchors.fill: parent

        NavigationFocusBorder {
            id: focusBorderItem
            navigationCtrl: navCtrl
        }

        border.color: ui.theme.strokeColor
        border.width: ui.theme.borderWidth
    }

    MouseArea {
        id: mouseAreaItem
        anchors.fill: parent

        onClicked: {
            root.ensureActiveFocus()
        }
    }

    Item {
        id: contentItemContaner
        objectName: "FocusableControlContent"
        anchors.fill: focusRectItem
    }
}
