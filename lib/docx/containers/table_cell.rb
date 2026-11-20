require 'docx/containers/text_run'
require 'docx/containers/container'

module Docx
  module Elements
    module Containers
      class TableCell
        include Container
        include Elements::Element

        def self.tag
          'tc'
        end

        def initialize(node, document_properties = {}, doc = nil)
          @node = node
          @properties_tag = 'tcPr'
          @document_properties = document_properties
          @document = doc
        end

        # Return text of paragraph's cell
        def to_s
          paragraphs.map(&:text).join('')
        end

        # Array of paragraphs contained within cell.
        # The document is given to the paragraphs so that Paragraph#style works.
        def paragraphs
          @node.xpath('w:p', Docx::NS).map { |p_node| Containers::Paragraph.new(p_node, @document_properties, @document) }
        end

        # Tables nested in the cell
        def tables
          @node.xpath('w:tbl', Docx::NS).map { |t_node| Containers::Table.new(t_node, @document_properties, @document) }
        end

        # Iterate over each text run within a paragraph's cell
        def each_paragraph
          paragraphs.each { |tr| yield(tr) }
        end

        # Number of grid columns covered by the cell (w:gridSpan)
        def grid_span
          span = @node.at_xpath('w:tcPr/w:gridSpan', Docx::NS)
          span ? span.attributes['val'].value.to_i : 1
        end

        alias_method :text, :to_s
      end
    end
  end
end
