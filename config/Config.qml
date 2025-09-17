pragma Singleton

import qs.utils
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property AppearanceConfig appearance: AppearanceConfig {}
    property GeneralConfig general: GeneralConfig {}
    property BackgroundConfig background: BackgroundConfig {}
    property BarConfig bar: BarConfig {}
    property BorderConfig border: BorderConfig {}
    property DashboardConfig dashboard: DashboardConfig {}
    property ControlCenterConfig controlCenter: ControlCenterConfig {}
    property LauncherConfig launcher: LauncherConfig {}
    property NotifsConfig notifs: NotifsConfig {}
    property OsdConfig osd: OsdConfig {}
    property SessionConfig session: SessionConfig {}
    property WInfoConfig winfo: WInfoConfig {}
    property LockConfig lock: LockConfig {}
    property UtilitiesConfig utilities: UtilitiesConfig {}
    property ServiceConfig services: ServiceConfig {}
    property UserPaths paths: UserPaths {}
}
