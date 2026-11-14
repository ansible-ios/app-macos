import Foundation
import WidgetEngineXPC

func installWidgetEngineService() {
    let serviceName = WidgetEngineXPC.embeddedServiceName() ?? "com.ansible.macos.WidgetEngine"
    WidgetEngineXPC.install(serviceName: serviceName)
}
