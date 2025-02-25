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
import MuseScore.Inspector 1.0

import "../../../common"

FocusableItem {
    id: root

    property QtObject model: null

    property NavigationPanel navigationPanel: null
    property int navigationRowStart: 1

    implicitHeight: contentColumn.height
    width: parent.width

    Column {
        id: contentColumn

        width: parent.width

        spacing: 12

        Item {
            height: childrenRect.height
            width: parent.width

            CheckBox {
                anchors.left: parent.left
                anchors.right: parent.horizontalCenter
                anchors.rightMargin: 2

                isIndeterminate: root.model ? root.model.isNienteCircleVisible.isUndefined : false
                checked: root.model && !isIndeterminate ? root.model.isNienteCircleVisible.value : false
                text: qsTrc("inspector", "Niente circle")

                navigation.name: "NienteCircleCheckBox"
                navigation.panel: root.navigationPanel
                navigation.row: root.navigationRowStart + 1
                navigation.enabled: root.enabled

                onClicked: { root.model.isNienteCircleVisible.value = !checked }
            }

            CheckBox {
                anchors.left: parent.horizontalCenter
                anchors.leftMargin: 2
                anchors.right: parent.right

                isIndeterminate: root.model ? root.model.allowDiagonal.isUndefined : false
                checked: root.model && !isIndeterminate ? root.model.allowDiagonal.value : false
                text: qsTrc("inspector", "Allow diagonal")

                navigation.name: "AllowDiagonalCheckBox"
                navigation.panel: root.navigationPanel
                navigation.row: root.navigationRowStart + 2
                navigation.enabled: root.enabled

                onClicked: { root.model.allowDiagonal.value = !checked }
            }
        }

        LineStyleSection {
            id: lineStyleSection
            lineStyle: root.model ? root.model.lineStyle : null
            dashLineLength: root.model ? root.model.dashLineLength : null
            dashGapLength: root.model ? root.model.dashGapLength : null

            navigationPanel: root.navigationPanel
            navigationRowStart: root.navigationRowStart + 3
        }

        SeparatorLine { anchors.margins: -10 }

        Item {
            height: childrenRect.height
            width: parent.width

            SpinBoxPropertyView {
                id: thicknessSection
                anchors.left: parent.left
                anchors.right: parent.horizontalCenter
                anchors.rightMargin: 2

                titleText: qsTrc("inspector", "Thickness")
                propertyItem: root.model ? root.model.thickness : null

                step: 0.1
                maxValue: 10
                minValue: 0.1
                decimals: 2

                navigationPanel: root.navigationPanel
                navigationRowStart: lineStyleSection.navigationRowEnd + 1
            }

            SpinBoxPropertyView {
                id: heightSection
                anchors.left: parent.horizontalCenter
                anchors.leftMargin: 2
                anchors.right: parent.right

                titleText: qsTrc("inspector", "Height")
                propertyItem: root.model ? root.model.height : null

                step: 0.1
                maxValue: 10
                minValue: 0.1
                decimals: 2

                navigationPanel: root.navigationPanel
                navigationRowStart: thicknessSection.navigationRowEnd + 1
            }
        }

        Item {
            height: childrenRect.height
            width: parent.width

            SpinBoxPropertyView {
                id: continiousHeightSection
                anchors.left: parent.left
                anchors.right: parent.horizontalCenter
                anchors.rightMargin: 2

                titleText: qsTrc("inspector", "Height (continuing to a new system)")
                propertyItem: root.model ? root.model.continiousHeight : null

                step: 0.1
                maxValue: 10
                minValue: 0.1
                decimals: 2

                navigationPanel: root.navigationPanel
                navigationRowStart: heightSection.navigationRowEnd + 1
            }
        }

        PlacementSection {
            propertyItem: root.model ? root.model.placement : null

            navigationPanel: root.navigationPanel
            navigationRowStart: continiousHeightSection.navigationRowEnd + 1
        }
    }
}

