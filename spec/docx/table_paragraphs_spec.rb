require 'docx'

describe 'paragraphs inside tables' do
  before do
    @doc = Docx::Document.open(File.join(File.dirname(__FILE__), '..', 'fixtures', 'tables.docx'))
  end

  it 'keeps the historical behaviour by default' do
    expect(@doc.paragraphs.size).to eq 5
    expect(@doc.paragraphs.none?(&:in_table?)).to be true
  end

  it 'returns table paragraphs in document order with include_tables' do
    paragraphs = @doc.paragraphs(include_tables: true)
    expect(paragraphs.size).to eq 354
    expect(paragraphs.count(&:in_table?)).to eq 349
    expect(paragraphs.find(&:in_table?).text).to eq 'ENGLISH'
  end

  it 'gives the style of paragraphs located in table cells' do
    cell_paragraph = @doc.tables[0].rows[0].cells[0].paragraphs[0]
    expect(cell_paragraph.style).to eq 'Normal'
  end

  it 'iterates over body elements in document order' do
    kinds = @doc.body_elements.map(&:class).uniq
    expect(kinds).to include(Docx::Elements::Containers::Table)
    expect(kinds).to include(Docx::Elements::Containers::Paragraph)
  end
end
