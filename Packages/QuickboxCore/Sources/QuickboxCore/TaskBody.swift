import Foundation

/// A task's multi-line description: the indented lines right under its task line.
///
///     - [ ] 14:02 Send the report id:a1b2c3d4
///       - add Q3 numbers
///       - CC the team
///
/// A body line starts with a space or a tab and is not blank. Blank lines inside the body separate
/// paragraphs and are written without indentation; an unindented line, or blank lines with no body
/// after them, end it. Mirrors `cloud/src/core/taskLine.ts`.
public enum TaskBody {
    public static let indent = "  "

    /// Whether `line` continues the body of the task above it.
    public static func isBodyLine(_ line: String) -> Bool {
        guard let first = line.first, first == " " || first == "\t" else { return false }
        return !line.allSatisfy(\.isWhitespace)
    }

    public static func isBlankLine(_ line: String) -> Bool {
        line.allSatisfy(\.isWhitespace)
    }

    /// Strips one level of indentation (a tab or up to two spaces), keeping deeper nesting.
    public static func unindent(_ line: String) -> String {
        if line.hasPrefix("\t") { return String(line.dropFirst()) }
        return String(line.dropFirst(line.prefix(2).prefix(while: { $0 == " " }).count))
    }

    /// The lines to write under a task line; empty when there is no body.
    public static func lines(_ body: String?) -> [String] {
        guard let body else { return [] }
        // Blank lines stay empty: editors strip trailing spaces, and the parser keeps them anyway.
        return body.components(separatedBy: "\n").map { $0.isEmpty ? "" : indent + $0 }
    }

    /// Normalizes a body: line endings unified, trailing spaces and leading or trailing blank lines
    /// dropped. Blank lines between paragraphs stay. Returns nil when nothing is left.
    public static func normalized(_ body: String?) -> String? {
        guard let body else { return nil }
        let lines = body
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
            .components(separatedBy: "\n")
            .map { String($0.reversed().drop(while: \.isWhitespace).reversed()) }
        guard let first = lines.firstIndex(where: { !$0.isEmpty }),
              let last = lines.lastIndex(where: { !$0.isEmpty }) else { return nil }
        return lines[first...last].joined(separator: "\n")
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
