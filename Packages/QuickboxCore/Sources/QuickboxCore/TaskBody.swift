import Foundation

/// A task's multi-line description: the indented lines right under its task line.
///
///     - [ ] 14:02 Send the report id:a1b2c3d4
///       - add Q3 numbers
///       - CC the team
///
/// A body line starts with a space or a tab and is not blank; a blank or unindented line ends
/// the body. Mirrors `cloud/src/core/taskLine.ts`.
public enum TaskBody {
    public static let indent = "  "

    /// Whether `line` continues the body of the task above it.
    public static func isBodyLine(_ line: String) -> Bool {
        guard let first = line.first, first == " " || first == "\t" else { return false }
        return !line.allSatisfy(\.isWhitespace)
    }

    /// Strips one level of indentation (a tab or up to two spaces), keeping deeper nesting.
    public static func unindent(_ line: String) -> String {
        if line.hasPrefix("\t") { return String(line.dropFirst()) }
        return String(line.dropFirst(line.prefix(2).prefix(while: { $0 == " " }).count))
    }

    /// The lines to write under a task line; empty when there is no body.
    public static func lines(_ body: String?) -> [String] {
        guard let body else { return [] }
        return body.components(separatedBy: "\n").map { indent + $0 }
    }

    /// Normalizes a body: line endings unified, trailing spaces and blank lines (which would end
    /// the body in the file) dropped. Returns nil when nothing is left.
    public static func normalized(_ body: String?) -> String? {
        guard let body else { return nil }
        let lines = body
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
            .components(separatedBy: "\n")
            .map { String($0.reversed().drop(while: \.isWhitespace).reversed()) }
            .filter { !$0.isEmpty }
        return lines.isEmpty ? nil : lines.joined(separator: "\n")
    }

    /// Splits typed text into the task line's text (first line) and its body (the rest).
    public static func split(_ text: String) -> (title: String, body: String?) {
        let unified = text.replacingOccurrences(of: "\r\n", with: "\n").replacingOccurrences(of: "\r", with: "\n")
        guard let newline = unified.firstIndex(of: "\n") else {
            return (unified.trimmingCharacters(in: .whitespaces), nil)
        }
        let title = String(unified[..<newline]).trimmingCharacters(in: .whitespaces)
        return (title, normalized(String(unified[unified.index(after: newline)...])))
    }

    /// Flips the Markdown checklist item (`- [ ] ` / `- [x] `) on line `index` of a body, keeping its
    /// indentation. Returns nil when that line is not a checklist item.
    public static func togglingChecklistItem(in body: String, atLine index: Int) -> String? {
        var lines = body.components(separatedBy: "\n")
        guard lines.indices.contains(index) else { return nil }
        let indent = lines[index].prefix(while: { $0 == " " || $0 == "\t" })
        let rest = lines[index].dropFirst(indent.count)
        let toggled: String
        if rest.hasPrefix("- [ ] ") {
            toggled = "- [x] " + rest.dropFirst(6)
        } else if rest.hasPrefix("- [x] ") || rest.hasPrefix("- [X] ") {
            toggled = "- [ ] " + rest.dropFirst(6)
        } else {
            return nil
        }
        lines[index] = indent + toggled
        return lines.joined(separator: "\n")
    }

    /// The inverse of `split`: the text a user edits, title first.
    public static func joined(title: String, body: String?) -> String {
        guard let body else { return title }
        return title + "\n" + body
    }
}
