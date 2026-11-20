require 'docx/containers/table_row'
require 'docx/containers/table_column'
require 'docx/containers/container'

module Docx
  module Elements
    module Containers
      class Table
        include Container
        include Elements::Element

        def self.tag
          'tbl'
        end

        def initialize(node, document_properties = {}, doc = nil)
          @node = node
          @properties_tag = 'tblGrid'
          @document_properties = document_properties
          @document = doc
        end

        # Array of row
        def rows
          @node.xpath('w:tr', Docx::NS).map { |r_node| Containers::TableRow.new(r_node, @document_properties, @document) }
        end

        def row_count
          @node.xpath('w:tr', Docx::NS).count
        end

        # Array of column
        def columns
          columns_containers = []
          (0..(column_count-1)).each do |i|
            columns_containers[i] = Containers::TableColumn.new(@node.xpath("w:tr//w:tc[#{i+1}]", Docx::NS),
                                                                @document_properties, @document)
          end
          columns_containers
        end

        def column_count
          @node.xpath('w:tblGrid/w:gridCol', Docx::NS).count
        end

        # All paragraphs of the table (all cells, nested tables included), in document order
        def paragraphs
          @node.xpath('descendant::w:p[not(ancestor::w:p)]', Docx::NS).map do |p_node|
            Containers::Paragraph.new(p_node, @document_properties, @document)
          end
        end

        # Iterate over each row within a table
        def each_rows
          rows.each { |r| yield(r) }
        end

        def to_s
          rows.map(&:to_s).join("\n")
        end

        alias_method :text, :to_s
      end
    end
  end
end
