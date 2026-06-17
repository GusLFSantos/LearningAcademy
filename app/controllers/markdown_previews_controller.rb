# Renders Markdown to sanitized HTML for the authoring live-preview pane,
# reusing the exact same server-side renderer the lessons use.
class MarkdownPreviewsController < ApplicationController
  def create
    render html: helpers.markdown(params[:text])
  end
end
