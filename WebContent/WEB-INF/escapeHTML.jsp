<%!

private String escapeHtml(String s) {
        if (s == null) return "";
        // order matters: escape & first
        s = s.replace("&", "&amp;");
        s = s.replace("<", "&lt;");
        s = s.replace(">", "&gt;");
        s = s.replace("\"", "&quot;");
        s = s.replace("'", "&#x27;");
        return s;
    }

%>