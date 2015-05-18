require 'es_map_editor/ui/chunk_renderer'

# Specialized renderer for rendering Map Editor Chunks with grid and border
# additions
class EditorChunkRenderer < ChunkRenderer
  attr_accessor :show_border
  attr_accessor :show_label
  attr_accessor :show_underlay
  attr_accessor :show_overlay

  def init
    super
    @show_border = false
    @show_label = false
    @show_underlay = false
    @show_overlay = false

    @underlay_texture = TextureCache.ui('grid_32x32_ff777777.png')
    @overlay_texture = TextureCache.ui('grid_32x32_ffffffff.png')
    @grid_underlay = Moon::Sprite.new(@underlay_texture)
    @grid_overlay  = Moon::Sprite.new(@overlay_texture)

    @border_renderer = BorderRenderer.new

    @label_color = Moon::Vector4.new(1, 1, 1, 1)
    @label_font = FontCache.font('uni0553', 16)
  end

  def render_label(x, y, z, options)
    oy = @label_font.size + 8
    @label_font.render(x, y - oy, z, @chunk.name, @label_color, outline: 0)
  end

  def render_content(x, y, z, options)
    return unless @chunk

    bound_rect = Moon::Rect.new(0, 0, *(@chunk.bounds.wh * 32))

    if options.fetch(:show_underlay, @show_underlay)
      @grid_underlay.clip_rect = bound_rect
      @grid_underlay.render(x, y, z)
    end

    super

    if options.fetch(:show_border, @show_border)
      @border_renderer.border_rect = bound_rect
      @border_renderer.render(x, y, z, options)
    end

    if options.fetch(:show_overlay, @show_overlay)
      @grid_overlay.clip_rect = bound_rect
      @grid_overlay.render(x, y, z)
    end

    render_label(x, y, z, options) if options.fetch(:show_label, @show_label)
  end
end
