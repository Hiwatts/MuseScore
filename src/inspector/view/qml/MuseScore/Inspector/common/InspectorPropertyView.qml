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
import QtQuick.Layouts 1.15

import MuseScore.Ui 1.0
import MuseScore.UiComponents 1.0
import MuseScore.Inspector 1.0

Column {
    id: root

    property PropertyItem propertyItem: null

    property NavigationPanel navigationPanel: null
    property int navigationRowStart: 0
    property int navigationRowEnd: menuButton.navigation.row
    property bool navigationEnabled: true

    property alias titleText: titleLabel.text
    property alias showTitle: titleLabel.visible
    property alias showMenuButton: menuButton.visible

    readonly property bool isStyled: propertyItem ? propertyItem.isStyled : false
    readonly property bool isModified: propertyItem ? propertyItem.isModified : false

    enabled: propertyItem && propertyItem.isEnabled
    visible: propertyItem && propertyItem.isVisible

    width: parent.width

    spacing: 8

    RowLayout {
        id: contentRow

        width: parent.width
        height: implicitHeight

        spacing: 4

        StyledTextLabel {
            id: titleLabel

            visible: !isEmpty
            Layout.alignment: Qt.AlignLeft
            Layout.fillWidth: true

            horizontalAlignment: Text.AlignLeft
        }

        MenuButton {
            id: menuButton

            height: 20
            width: height

            navigation.panel: root.navigationPanel
            navigation.row: root.navigationRowStart
            navigation.enabled: root.enabled && root.navigationEnabled && visible
            navigation.accessible.name: root.titleText + " " + qsTrc("inspector", "Menu")

            menuModel: {
                var result = []

                result.push({ title: qsTrc("inspector", "Reset"), enabled: root.isModified, icon: IconCode.NONE, id: "reset" })

                if (root.isStyled) {
                    if (root.isModified) {
                        result.push({ title: qsTrc("inspector", "Save as default style for this score"), enabled: true, icon: IconCode.SAVE, id: "save" })
                    } else {
                        result.push({ title: qsTrc("inspector", "This is set as the default style for this score"), enabled: false, icon: IconCode.TICK_RIGHT_ANGLE })
                    }
                }

                return result
            }

            menuAlign: Qt.AlignHCenter

            onHandleMenuItem: function(itemId) {
                switch (itemId) {
                case "reset":
                    root.propertyItem.resetToDefault()
                    break
                case "save":
                    root.propertyItem.applyToStyle()
                    break
                }
            }
        }
    }
}
