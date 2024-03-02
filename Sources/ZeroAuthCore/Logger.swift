import os.log

public struct Logger {
    
    public static func error(data: String) {
        os_log("%s", type: .error, data as CVarArg)
    }
    
    public static func info(data: String) {
        os_log("%s", type: .info, data as CVarArg)
    }
    
    public static func debug(data: String) {
        os_log("%s", type: .debug, data as CVarArg)
    }
}

