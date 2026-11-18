#if SHARE
import AnsibleContextShare
#else
import AnsibleContext
#endif

extension AccountContext: AccountContextProtocol {}
