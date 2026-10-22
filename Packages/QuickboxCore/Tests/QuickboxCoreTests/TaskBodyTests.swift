import Testing
@testable import QuickboxCore

struct TaskBodyTests {

    @Test
    func splitsTypedTextIntoTitleAndBody() {
        let parts = TaskBody.split("Send report !1\r\n- add Q3  \n\n  - nested\n")

        #expect(parts.title == "Send report !1")
        #expect(parts.body == "- add Q3\n  - nested")
    }

    @Test
    func singleLineTextHasNoBody() {
        #expect(TaskBody.split("  Buy milk ").title == "Buy milk")
        #expect(TaskBody.split("Buy milk\n \n").body == nil)
    }

    @Test
    func bodyRoundTripsThroughTheFile() {
        let body = "- add Q3\n  - nested"
        let lines = ["- [ ] 09:00 Send report"] + TaskBody.lines(body)

        #expect(lines == ["- [ ] 09:00 Send report", "  - add Q3", "    - nested"])
        #expect(InboxParser().parse(lines: lines, sourceID: "a.md").first?.body == body)
        #expect(InboxParser().parse(lines: lines, sourceID: "a.md").first?.lineCount == 3)
    }
}
