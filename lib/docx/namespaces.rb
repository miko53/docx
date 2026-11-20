# frozen_string_literal: true

module Docx
  # Namespaces given explicitly to every XPath query.
  # Without it Nokogiri collects and registers all the namespaces declared on
  # the document root (13 for a Word document) at *each* xpath call, which
  # dominates the parsing time on big documents.
  NS = { 'w' => 'http://schemas.openxmlformats.org/wordprocessingml/2006/main' }.freeze
end
