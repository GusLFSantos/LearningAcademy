module MarkdownHelper
  # Renders fenced code blocks with Rouge syntax highlighting, except ```mermaid
  # blocks which are emitted as <pre class="mermaid"> for client-side rendering.
  class Renderer < Redcarpet::Render::HTML
    def block_code(code, language)
      if language.to_s.strip == "mermaid"
        %(<pre class="mermaid">#{ERB::Util.html_escape(code)}</pre>)
      else
        lexer = ::Rouge::Lexer.find_fancy(language) || ::Rouge::Lexers::PlainText.new
        formatter = ::Rouge::Formatters::HTML.new
        body = formatter.format(lexer.lex(code))
        %(<div class="highlight"><pre><code>#{body}</code></pre></div>)
      end
    end
  end

  MARKDOWN = Redcarpet::Markdown.new(
    Renderer.new(hard_wrap: true, link_attributes: { rel: "nofollow noopener", target: "_blank" }),
    autolink: true,
    fenced_code_blocks: true,
    tables: true,
    strikethrough: true,
    superscript: true,
    no_intra_emphasis: true,
    space_after_headers: true
  )

  ALLOWED_TAGS = %w[
    h1 h2 h3 h4 h5 h6 p br hr ul ol li blockquote pre code span div
    a strong em del sup table thead tbody tr th td img
  ].freeze

  ALLOWED_ATTRS = %w[href title class src alt rel target].freeze

  def markdown(text)
    return "".html_safe if text.blank?
    sanitize(MARKDOWN.render(text), tags: ALLOWED_TAGS, attributes: ALLOWED_ATTRS)
  end
end
