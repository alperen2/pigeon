import Testing
@testable import QuickboxCore

struct TaskBodyTests {

    @Test
    func splitsTypedTextIntoTitleAndBody() {
        let parts = TaskBody.split("Send report !1\r\n- add Q3  \n\n  - nested\n")

        #expect(parts.title == "Send report !1")
        #expect(parts.body == "- add Q3\n\n  - nested")
    }

    @Test
    func singleLineTextHasNoBody() {
        #expect(TaskBody.split("  Buy milk ").title == "Buy milk")
        #expect(TaskBody.split("Buy milk\n \n").body == nil)
    }

    @Test
    func blankLinesBetweenParagraphsRoundTrip() {
        let body = "First paragraph.\n\nSecond one\n  - nested"
        let lines = ["- [ ] 09:00 Note"] + TaskBody.lines(body) + ["", "- [ ] 10:00 Next"]

        #expect(lines == ["- [ ] 09:00 Note", "  First paragraph.", "", "  Second one", "    - nested", "", "- [ ] 10:00 Next"])
        let items = InboxParser().parse(lines: lines, sourceID: "a.md")
        #expect(items.first?.body == body)
        #expect(items.first?.lineCount == 5)
        #expect(items.last?.lineIndex == 6)
    }

    @Test
    func editableTextShowsTokensButNotProvenance() {
        let line = "- [ ] 09:00 Ship it !1 @Launch #work due:2026-10-24 time:30m for:me by:claude from:k3f9x2ab id:a1b2c3d4"
        let item = InboxParser().parse(lines: [line], sourceID: "a.md")[0]

        #expect(item.editableText == "Ship it !1 @Launch #work due:2026-10-24 for:me time:30m")
    }

    @Test
    func togglesOnlyChecklistLines() {
        let body = "Plan\n- [ ] call\n  - [X] nested\n- not a box"

        #expect(TaskBody.togglingChecklistItem(in: body, atLine: 1) == "Plan\n- [x] call\n  - [X] nested\n- not a box")
        #expect(TaskBody.togglingChecklistItem(in: body, atLine: 2) == "Plan\n- [ ] call\n  - [ ] nested\n- not a box")
        #expect(TaskBody.togglingChecklistItem(in: body, atLine: 0) == nil)
        #expect(TaskBody.togglingChecklistItem(in: body, atLine: 3) == nil)
        #expect(TaskBody.togglingChecklistItem(in: body, atLine: 9) == nil)
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
