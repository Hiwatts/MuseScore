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
#ifndef MU_API_AUTOBOTAPI_H
#define MU_API_AUTOBOTAPI_H

#include <QJSValue>
#include <QEventLoop>

#include "apiobject.h"
#include "async/asyncable.h"

#include "modularity/ioc.h"
#include "project/iprojectfilescontroller.h"
#include "autobot/iautobotconfiguration.h"
#include "iinteractive.h"

namespace mu::api {
class AutobotApi : public ApiObject, public async::Asyncable
{
    Q_OBJECT

    INJECT(api, autobot::IAutobotConfiguration, autobotConfiguration)
    INJECT(api, project::IProjectFilesController, projectFilesController)
    INJECT(api, framework::IInteractive, interactive)

public:
    explicit AutobotApi(IApiEngine* e);

    Q_INVOKABLE void setInterval(int msec);
    Q_INVOKABLE void runTestCase(const QJSValue& testCase);

    Q_INVOKABLE bool openProject(const QString& name);
    Q_INVOKABLE void saveProject(const QString& name = QString());

    Q_INVOKABLE void abort();
    Q_INVOKABLE bool pause();
    Q_INVOKABLE void sleep(int msec = -1) const;
    Q_INVOKABLE void waitPopup() const;
    Q_INVOKABLE void seeChanges(int msec = 300);
    Q_INVOKABLE void async(const QJSValue& func, const QJSValueList& args = QJSValueList());
    Q_INVOKABLE int randomInt(int min, int max) const;

private:

    struct TestCase
    {
        QJSValue testCase;
        QJSValue steps;
        int stepsCount = 0;
        int currentStepIdx = -1;
        int finishedCount = 0;
        QEventLoop loop;
    };

    void nextStep();

    int m_intervalMsec = 1000;
    TestCase m_testCase;
    bool m_abort = false;
};
}

#endif // MU_API_AUTOBOTAPI_H
