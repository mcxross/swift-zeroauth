public protocol Provider {
    var authorizationEndpoint: String { get }
    var tokenEndpoint: String { get }
    var revocationEndpoint: String? { get }
    var registrationEndpoint: String? { get }
}


public struct Ghost: Provider {
    public var authorizationEndpoint: String = ""
    public var tokenEndpoint: String = ""
    public var revocationEndpoint: String? = nil
    public var registrationEndpoint: String? = nil
    
    public init(authorizationEndpoint: String = "",
                tokenEndpoint: String = "",
                revocationEndpoint: String? = nil,
                registrationEndpoint: String? = nil) {
        self.authorizationEndpoint = authorizationEndpoint
        self.tokenEndpoint = tokenEndpoint
        self.revocationEndpoint = revocationEndpoint
        self.registrationEndpoint = registrationEndpoint
    }
}

public struct Facebook: Provider {
    public var authorizationEndpoint: String = "https://www.facebook.com/v2.8/dialog/oauth"
    public var tokenEndpoint: String = "https://graph.facebook.com/v2.8/oauth/access_token"
    public var revocationEndpoint: String? = nil
    public var registrationEndpoint: String? = nil
}

public struct Google: Provider {
    public var authorizationEndpoint: String = ""
    public var tokenEndpoint: String = ""
    public var revocationEndpoint: String? = nil
    public var registrationEndpoint: String? = nil
    
    public init(authorizationEndpoint: String = "https://accounts.google.com/o/oauth2/v2/auth",
                tokenEndpoint: String = "https://www.googleapis.com/oauth2/v4/token",
                revocationEndpoint: String? = "https://accounts.google.com/o/oauth2/revoke",
                registrationEndpoint: String? = "https://accounts.google.com/o/oauth2/device/code") {
        self.authorizationEndpoint = authorizationEndpoint
        self.tokenEndpoint = tokenEndpoint
        self.revocationEndpoint = revocationEndpoint
        self.registrationEndpoint = registrationEndpoint
    }
}

public struct Apple: Provider {
    public var authorizationEndpoint: String = "https://appleid.apple.com/auth/authorize"
    public var tokenEndpoint: String = "https://appleid.apple.com/auth/token"
    public var revocationEndpoint: String? = nil
    public var registrationEndpoint: String? = nil
}

public struct Twitch: Provider {
    public var authorizationEndpoint: String = "https://id.twitch.tv/oauth2/authorize"
    public var tokenEndpoint: String = "https://id.twitch.tv/oauth2/token"
    public var revocationEndpoint: String? = nil
    public var registrationEndpoint: String? = nil
}

public struct Slack: Provider {
    public var authorizationEndpoint: String = "https://slack.com/oauth/authorize"
    public var tokenEndpoint: String = "https://slack.com/api/oauth.access"
    public var revocationEndpoint: String? = nil
    public var registrationEndpoint: String? = nil
}
