import Foundation

typealias PeerId = Int64

protocol Peer {
    var containerPeerId: PeerId? { get }
}

struct TelegramChannel: Peer {
    let linkedCommunityId: PeerId?
    var containerPeerId: PeerId? { linkedCommunityId }
}

struct TelegramUser: Peer {
    let linkedCommunityId: PeerId?
    var containerPeerId: PeerId? { linkedCommunityId }
}

struct OrdinaryPeer: Peer {
    var containerPeerId: PeerId? { nil }
}

final class Context {
    var opened: [PeerId] = []
}

func showCommunityView(_ context: Context, communityId: PeerId) {
    context.opened.append(communityId)
}

final class Row {
    var peer: (any Peer)?
    var disableCommunityDropdown = false
    var isTopic = false
    let context = Context()

__PRODUCTION__
}

var checks = 0
func expect(_ condition: @autoclosure () -> Bool, _ name: String) {
    guard condition() else {
        fatalError("FAIL: " + name)
    }
    checks += 1
}

let row = Row()
let community: PeerId = 1090000000011
row.peer = TelegramUser(linkedCommunityId: community)
expect(row.showsCommunityDropdown, "linked bot exposes avatar dropdown")
row.openCommunityPreview()
expect(row.context.opened == [community], "linked bot opens its community")
row.peer = TelegramChannel(linkedCommunityId: community)
expect(row.showsCommunityDropdown, "linked group or channel keeps dropdown")
row.openCommunityPreview()
expect(row.context.opened == [community, community], "channel opens same community")
row.disableCommunityDropdown = true
expect(!row.showsCommunityDropdown, "nested community row suppresses dropdown")
row.disableCommunityDropdown = false
row.isTopic = true
expect(!row.showsCommunityDropdown, "forum topic suppresses dropdown")
row.isTopic = false
row.peer = TelegramUser(linkedCommunityId: nil)
expect(!row.showsCommunityDropdown, "unlink removes bot dropdown without new row")
row.openCommunityPreview()
expect(row.context.opened.count == 2, "unlinked peer cannot open stale community")
row.peer = TelegramUser(linkedCommunityId: community + 1)
expect(row.showsCommunityDropdown, "relink restores dropdown without new row")
row.openCommunityPreview()
expect(row.context.opened.last == community + 1, "relink opens new community")
row.peer = OrdinaryPeer()
expect(!row.showsCommunityDropdown, "ordinary peer has no dropdown")
row.peer = nil
expect(!row.showsCommunityDropdown, "absent peer has no dropdown")
print("Community dropdown: \(checks) checks PASS")
