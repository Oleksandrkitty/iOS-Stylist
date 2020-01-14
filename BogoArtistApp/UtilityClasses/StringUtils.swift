class StringUtils {

    static func joinNullableStrings(_ values: [String?], separator: String = " ") -> String {
        return values.filter{ $0 != nil }.map { $0! }.joined(separator: separator)
    }

}
