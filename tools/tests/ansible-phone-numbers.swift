import Foundation

@main
struct AnsiblePhoneNumberTests {
    static func main() {
        precondition(AnsiblePhoneNumber.isValid("+777 0123 4567"))
        precondition(AnsiblePhoneNumber.isValid("+777 8"))
        precondition(!AnsiblePhoneNumber.isValid("+777"))
        precondition(!AnsiblePhoneNumber.isValid("+777 0123 45678"))
        precondition(!AnsiblePhoneNumber.hasPrefix("+7 701 234 5678"))
        precondition(AnsiblePhoneNumber.digits("+777 (0123) 4567") == "77701234567")
        precondition(AnsiblePhoneNumber.formatted("+777 0123 4567") == "+777 01234567")
        precondition(AnsiblePhoneNumber.formatted("+777 8") == "+777 8")
        print("Ansible phone number checks passed")
    }
}
