require 'docx/containers/table_cell'
require 'docx/containers/container'

module Docx
  module Elements
    module Containers
      class TableRow
        include Container
        include Elements::Element

        def self.tag
          'tr'
        end

        def initialize(node, document_properties = {}, doc = nil)
          @node = node
          @properties_tag = 'trPr'
          @document_properties = document_properties
          @document = doc
        end

        # Array of cells contained within row
        def cells
          @node.xpath('w:tc', Docx::NS).map { |c_node| Containers::TableCell.new(c_node, @document_properties, @document) }
        end

        def to_s
          cells.map(&:to_s).join("\t")
        end
      end
    end
  end
end
