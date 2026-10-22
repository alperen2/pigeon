import Foundation

public struct InboxItem: Identifiable, Equatable, Sendable {
    public let id: String
    public let text: String
    public var tags: [String]
    public var dueDate: String?
    public var priority: Int?
    public var projectName: String?
    public var metadata: [String: String] // Holds dynamic key:value pairs like time:30m
    public var taskID: String? // Stable `id:` token; nil for legacy lines written before ids existed
    /// The indented lines under the task line, unindented and joined with "\n" (see `TaskBody`).
    public var body: String?
    public let time: String
    public let isCompleted: Bool
    public let lineIndex: Int
    public let rawLine: String

    public init(
        id: String,
        text: String,
        tags: [String] = [],
        dueDate: String? = nil,
        priority: Int? = nil,
        projectName: String? = nil,
        metadata: [String: String] = [:],
        taskID: String? = nil,
        body: String? = nil,
        time: String,
        isCompleted: Bool,
        lineIndex: Int,
        rawLine: String
    ) {
        self.id = id
        self.text = text
        self.tags = tags
        self.dueDate = dueDate
        self.priority = priority
        self.projectName = projectName
        self.metadata = metadata
        self.taskID = taskID
        self.body = body
        self.time = time
        self.isCompleted = isCompleted
        self.lineIndex = lineIndex
        self.rawLine = rawLine
    }

    /// Lines the task occupies in its file: the task line plus its body lines.
    public var lineCount: Int {
        1 + TaskBody.lines(body).count
    }
}
