module UI
  module OUI
    # maximum size in bytes of a single data buffer passed to uiAllocData().
    MAX_DATASIZE = 4096
    # maximum depth of nested containers
    MAX_DEPTH = 64
    # maximum number of buffered input events
    MAX_INPUT_EVENTS = 64
    # consecutive click threshold in ms
    CLICK_THRESHOLD = 250

    # the item is inactive
    COLD = 0
    # the item is inactive, but the cursor is hovering over this item
    HOT = 1
    # the item is toggled, activated, focused (depends on item kind)
    ACTIVE = 2
    # the item is unresponsive
    FROZEN = 3

    # attachments (bit 5-8)
    # fully valid when parent uses LAYOUT model
    # partially valid when in FLEX model

    # anchor to left item or left side of parent
    LEFT = 0x020
    # anchor to top item or top side of parent
    TOP = 0x040
    # anchor to right item or right side of parent
    RIGHT = 0x080
    # anchor to bottom item or bottom side of parent
    DOWN = 0x100
    # anchor to both left and right item or parent borders
    HFILL = 0x0a0
    # anchor to both top and bottom item or parent borders
    VFILL = 0x140
    # center horizontally, with left margin as offset
    HCENTER = 0x000
    # center vertically, with top margin as offset
    VCENTER = 0x000
    # center in both directions, with left/top margin as offset
    CENTER = 0x000
    # anchor to all four directions
    FILL = 0x1e0
    # when wrapping, put this element on a new line
    # wrapping layout code auto-inserts BREAK flags,
    # drawing routines can read them with uiGetLayout()
    BREAK = 0x200

    # on button 0 down
    BUTTON0_DOWN = 0x0400
    # on button 0 up
    # when this event has a handler, uiGetState() will return ACTIVE as
    # long as button 0 is down.
    BUTTON0_UP = 0x0800
    # on button 0 up while item is hovered
    # when this event has a handler, uiGetState() will return ACTIVE
    # when the cursor is hovering the items rectangle; this is the
    # behavior expected for buttons.
    BUTTON0_HOT_UP = 0x1000
    # item is being captured (button 0 constantly pressed);
    # when this event has a handler, uiGetState() will return ACTIVE as
    # long as button 0 is down.
    BUTTON0_CAPTURE = 0x2000
    # on button 2 down (right mouse button, usually triggers context menu)
    BUTTON2_DOWN = 0x4000
    # item has received a scrollwheel event
    # the accumulated wheel offset can be queried with uiGetScroll()
    SCROLL = 0x8000
    # item is focused and has received a key-down event
    # the respective key can be queried using uiGetKey() and uiGetModifier()
    KEY_DOWN = 0x10000
    # item is focused and has received a key-up event
    # the respective key can be queried using uiGetKey() and uiGetModifier()
    KEY_UP = 0x20000
    # item is focused and has received a character event
    # the respective character can be queried using uiGetKey()
    CHAR = 0x40000

    # these bits, starting at bit 24, can be safely assigned by the
    # application, e.g. as item types, other event types, drop targets, etc.
    # they can be set and queried using uiSetFlags() and uiGetFlags()
    #USERMASK = 0xff000000
    USERMASK = 0x7f000000

    # a special mask passed to uiFindItem()
    #ANY = 0xffffffff
    ANY = 0x7fffffff

    # flex-direction (bit 0+1)

    # left to right
    ROW = 0x002
    # top to bottom
    COLUMN = 0x003

    # model (bit 1)

    # free layout
    LAYOUT = 0x000
    # flex model
    FLEX = 0x002

    # flex-wrap (bit 2)

    # single-line
    NOWRAP = 0x000
    # multi-line, wrap left to right
    WRAP = 0x004


    # justify-content (start, end, center, space-between)
    # at start of row/column
    START = 0x008
    # at center of row/column
    MIDDLE = 0x000
    # at end of row/column
    L_END = 0x010
    # insert spacing to stretch across whole row/column
    JUSTIFY = 0x018

    # align-items
    # can be implemented by putting a flex container in a layout container,
    # then using TOP, DOWN, VFILL, VCENTER, etc.
    # FILL is equivalent to stretch/grow

    # align-content (start, end, center, stretch)
    # can be implemented by putting a flex container in a layout container,
    # then using TOP, DOWN, VFILL, VCENTER, etc.
    # FILL is equivalent to stretch; space-between is not supported.

    # bit 0-2
    ITEM_BOX_MODEL_MASK = 0x000007
    # bit 0-4
    ITEM_BOX_MASK       = 0x00001F
    # bit 5-8
    ITEM_LAYOUT_MASK = 0x0003E0
    # bit 9-18
    ITEM_EVENT_MASK  = 0x07FC00
    # item is frozen (bit 19)
    ITEM_FROZEN      = 0x080000
    # item handle is pointer to data (bit 20)
    ITEM_DATA      = 0x100000
    # item has been inserted (bit 21)
    ITEM_INSERTED  = 0x200000
    # horizontal size has been explicitly set (bit 22)
    ITEM_HFIXED      = 0x400000
    # vertical size has been explicitly set (bit 23)
    ITEM_VFIXED      = 0x800000
    # bit 22-23
    ITEM_FIXED_MASK  = 0xC00000

    # which flag bits will be compared
    ITEM_COMPARE_MASK = ITEM_BOX_MODEL_MASK | (ITEM_LAYOUT_MASK & ~BREAK) | ITEM_EVENT_MASK | USERMASK

    MAX_KIND = 16

    ANY_BUTTON0_INPUT = BUTTON0_DOWN | BUTTON0_UP | BUTTON0_HOT_UP | BUTTON0_CAPTURE
    ANY_BUTTON2_INPUT = BUTTON2_DOWN
    ANY_MOUSE_INPUT = ANY_BUTTON0_INPUT | ANY_BUTTON2_INPUT
    ANY_KEY_INPUT = KEY_DOWN | KEY_UP | CHAR
    ANY_INPUT = ANY_MOUSE_INPUT | ANY_KEY_INPUT

    class Vec2
      attr_accessor :x
      attr_accessor :y

      def initialize(x = 0, y = 0)
        @x, @y = x, y
      end
    end

    class Rect
      attr_accessor :x
      attr_accessor :y
      attr_accessor :w
      attr_accessor :h

      def initialize(x = 0, y = 0, w = 0, h = 0)
        @x, @y, @w, @h = x, y, w, h
      end
    end

    class InputEvent
      attr_accessor :event

      def initialize(key = 0, mod = 0, event = 0)
        @key = key
        @mod = mod
        @event = event
      end
    end

    class Item
      attr_accessor :handle
      attr_accessor :flags
      attr_accessor :firstkid
      attr_accessor :nextitem
      attr_accessor :margins
      attr_accessor :size

      def initialize
        @handle = nil
        @flags = 0
        @firstkid = -1
        @nextitem = -1
        @margins = Array.new(4, 0)
        @size = Array.new(2, 0)
      end
    end

    class Context

      MAX_INPUT_EVENTS = 100
      # extra item flags

      def initialize(item_capacity, buffer_capacity)
        @item_capacity = item_capacity
        @buffer_capacity = buffer_capacity
        @handler = nil
        @handle = nil
        @buttons = 0
        @last_buttons = 0
        @active_button_modifier = 0
        @start_cursor = Vec2.new
        @last_cursor = Vec2.new
        @cursor = Vec2.new
        @scroll = Vec2.new
        @active_item = -1
        @focus_item = -1
        @last_hot_item = -1
        @last_click_item = -1
        @hot_item = -1
        @state = :idle
        @stage = :process
        @active_key = 0
        @active_modifier = 0
        @active_button_modifier = 0
        @last_timestamp = 0
        @last_click_timestamp = 0
        @clicks = 0
        @count = 0
        @last_count = 0
        @eventcount = 0
        @datasize = 0
        @items = Array.new(@item_capacity) { Item.new }
        @data = Array.new(@buffer_capacity, nil)
        @last_items = Array.new(@item_capacity) { Item.new }
        @item_map = Array.new(@item_capacity, nil)
        @events = Array.new(MAX_INPUT_EVENTS) { InputEvent.new }

        clear
        clear_state
      end

      def clear
        @last_count = @count
        @count = 0
        @datasize = 0
        @hot_item = -1
        itms = @items
        @items = @last_items
        @last_items = itms
        @last_count.times { |i| @item_map[i] = -1 }
      end

      def set_context_handle(handle)
        @handle = handle
      end

      def context_handle
        @handle
      end

      def set_button(button, mod, enabled)
        mask = 1 << button
        @buttons = enabled ? (@buttons | mask) : (@buttons & ~mask)
        @active_button_modifier = mod
      end

      private def add_input_event(event)
        return if @eventcount == MAX_INPUT_EVENTS
        @events[@eventcount] = event
        @eventcount += 1
      end

      private def clear_input_events
        @eventcount = 0
        @scroll.x = 0
        @scroll.y = 0
      end

      def set_key(key, mod, enabled)
        add_input_event InputEvent.new(key, mod, (enabled ? KEY_DOWN : KEY_UP))
      end

      def set_char(value)
        add_input_event InputEvent.new(value, 0, CHAR)
      end

      def set_scroll(x, y)
        @scroll.x += x
        @scroll.y += y
      end

      def scroll
        @scroll.dup
      end

      def last_button(button)
        (@last_buttons & (1 << button)) != 0 ? true : false
      end

      def button(button)
        (@buttons & (1 << button)) != 0 ? true : false
      end

      def button_pressed(button)
        !last_button(button) && button(button)
      end

      def button_released(button)
        last_button(button) && !button(button)
      end

      def set_cursor(x, y)
        @cursor.x = x
        @cursor.y = y
      end

      def cursor
        @cursor.dup
      end

      def cursor_start
        @cursor_start.dup
      end

      def cursor_delta
        Vec2.new @cursor.x - @last_cursor.x, @cursor.y - @last_cursor.y
      end

      def cursor_start_delta
        Vec2.new @cursor.x - @start_cursor.x, @cursor.y - @start_cursor.y
      end

      def key
        @active_key
      end

      def modifier
        @active_modifier
      end

      def item_count
        @count
      end

      def last_item_count
        @last_count
      end

      def alloc_size
        @datasize
      end

      def item_ptr(item)
        raise unless item >= 0
        raise unless item < @count
        @items[item]
      end

      def last_item_ptr(item)
        raise unless item >= 0
        raise unless item < @last_count
        @last_items[item]
      end

      def hot_item
        @hot_item
      end

      def focus(item)
        raise unless item >= -1
        raise unless item < @count
        raise if @stage == :layout
        @focus_item = item
      end

      private def validate_state_items
        @last_hot_item = recover_item @last_hot_item
        @active_item = recover_item @active_item
        @focus_item = recover_item @focus_item
        @last_click_item = recover_item @last_click_item
      end

      def focused_item
        @focus_item
      end

      def begin_layout
        raise unless @stage == :process
        clear
        @stage = :layout
      end

      def clear_state
        @last_hot_item = -1
        @active_item = -1
        @focus_item = -1
        @last_click_item = -1
      end

      def item
        raise unless @stage == :layout
        raise unless @count < @item_capacity
        idx = @count
        @count += 1
        item = @items[idx] = Item.new
        item.firstkid = -1
        item.nextitem = -1
        idx
      end

      def notify_item(item, event)
        return unless @handler
        raise unless (event & ITEM_EVENT_MASK) == event
        pitem = item_ptr item
        if (pitem.flags & event) != 0
          @handler.call(self, item, event)
        end
      end

      private def last_child(item)
        item = first_child item
        return -1 if item < 0
        loop do
          nextitem = next_sibling item
          return item if nextitem < 0
          item = nextitem
        end
        raise
      end

      def append(item, sibling)
        raise unless sibling > 0
        pitem = item_ptr(item)
        psibling = item_ptr(sibling)
        raise if (psibling.flags & ITEM_INSERTED) != 0
        psibling.nextitem = pitem.nextitem
        psibling.flags |= ITEM_INSERTED
        pitem.nextitem = sibling
        sibling
      end

      def insert(item, child)
        raise unless child > 0
        pparent = item_ptr item
        pchild = item_ptr child
        raise if (pchild.flags & ITEM_INSERTED) != 0
        if pparent.firstkid < 0
          pparent.firstkid = child
          pchild.flags |= ITEM_INSERTED
        else
          append last_child(item), child
        end
        child
      end

      def insert_front(item, child)
        insert item, child
      end

      def insert_back(item, child)
        raise unless child > 0
        pparent = item_ptr item
        pchild = item_ptr child
        raise if (pchild.flags & ITEM_INSERTED) != 0
        pchild.nextitem = pparent.firstkid
        pparent.firstkid = child
        pchild.flags |= ITEM_INSERTED
        child
      end

      private def toggle_item_flags(pitem, flags, enable)
        if enable
          pitem.flags |= flags
        else
          pitem.flags &= ~flags
        end
      end

      private def set_item_flags_mask(pitem, flags, mask)
        raise unless (flags & mask) == flags
        pitem.flags &= ~mask
        pitem.flags |= flags & mask
      end

      def set_frozen(item, enable)
        pitem = item_ptr item
        toggle_item_flags pitem, ITEM_FROZEN, enable
      end

      def set_size(item, w, h)
        pitem = item_ptr item
        pitem.size[0] = w
        pitem.size[1] = h
        toggle_item_flags pitem, ITEM_HFIXED, w != 0
        toggle_item_flags pitem, ITEM_VFIXED, h != 0
      end

      def width(item)
        item_ptr(item).size[0]
      end

      def height(item)
        item_ptr(item).size[1]
      end

      def set_layout(item, flags)
        pitem = item_ptr item
        set_item_flags_mask pitem, flags, ITEM_LAYOUT_MASK
      end

      def layout(item)
        item_ptr(item).flags & ITEM_LAYOUT_MASK
      end

      def set_box(item, flags)
        pitem = item_ptr item
        set_item_flags_mask pitem, flags, ITEM_BOX_MASK
      end

      def box(item)
        item_ptr(item).flags & ITEM_BOX_MASK
      end

      def set_margins(item, l, t, r, b)
        pitem = item_ptr item
        pitem.margins[0] = l
        pitem.margins[1] = t
        pitem.margins[2] = r
        pitem.margins[3] = b
      end

      def get_margin_left(item)
        item_ptr(item).margins[0]
      end

      def get_margin_top(item)
        item_ptr(item).margins[1]
      end

      def get_margin_right(item)
        item_ptr(item).margins[2]
      end

      def get_margin_down(item)
        item_ptr(item).margins[3]
      end

      def full_item_margin(pitem, dim)
        pitem.margins[dim] + pitem.margins[dim + 2]
      end

      def full_item_width(pitem, dim)
        full_item_margin(pitem, dim) + pitem.size[dim]
      end

      private def compute_imposed_size(pitem, dim)
        need_size = 0
        kid = pitem.firstkid
        while kid >= 0
          pkid = item_ptr kid
          kidsize = full_item_width pkid, dim
          need_size = [need_size, kidsize].max
          kid = next_sibling kid
        end
        pitem.size[dim] = need_size
      end

      private def compute_stacked_size(pitem, dim)
        need_size = 0
        kid = pitem.firstkid
        while kid >= 0
          pkid = item_ptr kid
          need_size += full_item_width pkid, dim
          kid = next_sibling kid
        end
        pitem.size[dim] = need_size
      end

      private def compute_wrapped_stacked_size(pitem, dim)
        need_size = 0
        need_size2 = 0
        kid = pitem.firstkid
        while kid >= 0
          pkid = item_ptr kid

          if (pkid.flags & BREAK) != 0
            need_size2 = [need_size2, need_size].max
            need_size = 0
          end

          need_size += full_item_width pkid, dim
          kid = next_sibling kid
        end
        pitem.size[dim] = [need_size2, need_size].max
      end

      private def compute_wrapped_size(pitem, dim)
        need_size = 0
        need_size2 = 0
        kid = pitem.firstkid
        while kid >= 0
          pkid = item_ptr kid

          if (pkid.flags & BREAK) != 0
            need_size2 += need_size
            need_size = 0
          end

          kidsize = full_item_width pkid, dim
          need_size = [need_size, kidsize].max
          kid = next_sibling kid
        end
        pitem.size[dim] = need_size2 + need_size
      end

      private def compute_size(item, dim)
        pitem = item_ptr item
        kid = pitem.firstkid
        while kid >= 0
          compute_size kid, dim
          kid = next_sibling kid
        end

        return if pitem.size[dim] != 0

        case (pitem.flags & ITEM_BOX_MODEL_MASK)
        when COLUMN | WRAP
          if dim != 0
            compute_stacked_size pitem, 1
          else
            compute_imposed_size pitem, 0
          end
        when ROW | WRAP
          if dim == 0
            compute_wrapped_stacked_size pitem, 0
          else
            compute_wrapped_size pitem, 1
          end
        when COLUMN, ROW
          if (pitem.flags & 1) == dim
            compute_stacked_size pitem, dim
          else
            compute_imposed_size pitem, dim
          end
        else
          compute_imposed_size pitem, dim
        end
      end

      private def arrange_stacked(pitem, dim, wrap)
        wdim = dim + 2
        space = pitem.size[dim]
        max_x2 = pitem.margins[dim].to_f + space.to_f

        start_kid = pitem.firstkid
        while start_kid >= 0
          used = 0
          count = 0
          squeezed_count = 0
          total = 0
          hardbreak = false
          kid = start_kid
          end_kid = -1

          while kid >= 0
            pkid = item_ptr kid
            flags = (pkid.flags & ITEM_LAYOUT_MASK) >> dim
            fflags = (pkid.flags & ITEM_FIXED_MASK) >> dim
            extnd = used

            if flags.masked?(HFILL)
              count += 1
              extnd += full_item_margin pkid, dim
            else
              squeezed_count += 1 if !fflags.masked?(ITEM_HFIXED)
              extnd += full_item_width pkid, dim
            end

            if wrap && ((total != 0) && ((extnd > space) || ((pkid.flags & BREAK) != 0)))
              end_kid = kid
              hardbreak = pkid.flags.masked?(BREAK)
              pkid.flags |= BREAK
              break
            else
              used = extnd
              kid = next_sibling kid
            end
            total += 1
          end

          extra_space = space - used
          filler = 0.0
          spacer = 0.0
          extra_margin = 0.0
          eater = 0.0

          if extra_space > 0
            if count != 0
              filler = extra_space.to_f / count
            elsif total != 0
              case (pitem.flags & JUSTIFY)
              when JUSTIFY
                if !wrap || ((end_kid != -1) && !hardbreak)
                  spacer = extra_space.to_f / (total - 1)
                end
              when START
                #
              when L_END
                extra_margin = extra_space
              else
                extra_margin = extra_space / 2.0
              end
            end
          elsif !wrap && (extra_space < 0)
            eater = extra_space.to_f / squeezed_count
          end

          x = pitem.margins[dim]

          kid = start_kid
          while kid != end_kid
            pkid = item_ptr kid
            flags = (pkid.flags & ITEM_LAYOUT_MASK) >> dim
            fflags = (pkid.flags & ITEM_FIXED_MASK) >> dim

            x += pkid.margins[dim] + extra_margin

            x1 = if flags.masked?(HFILL)
              x + filler
            elsif flags.masked?(ITEM_HFIXED)
              x + pkid.size[dim]
            else
              x + [0.0, pkid.size[dim] + eater].max
            end

            ix0 = x
            ix1 = if wrap
              [max_x2 - pkid.margins[wdim], x1].min
            else
              x1
            end

            pkid.margins[dim] = ix0
            pkid.size[dim] = ix1 - ix0
            x = x1 + pkid.margins[wdim]

            kid = next_sibling kid
            extra_margin = spacer
          end

          start_kid = end_kid
        end
      end

      private def arrange_imposed_range(pitem, dim, start_kid, end_kid, offset, space)
        wdim = dim + 2

        kid = start_kid
        while kid != end_kid
          pkid = item_ptr kid

          flags = (pkid.flags & ITEM_LAYOUT_MASK) >> dim

          case (flags & HFILL)
          when HCENTER
            pkid.margins[dim] += ((space - pkid.size[dim]) / 2 - pkid.margins[wdim]).to_i
          when RIGHT
            pkid.margins[dim] += space - pkid.size[dim] - pkid.margins[wdim]
          when HFILL
            pkid.size[dim] = [0, space - pkid.margins[dim] - pkid.margins[wdim]].max
          end
          pkid.margins[dim] += offset

          kid = next_sibling kid
        end
      end

      private def arrange_imposed(pitem, dim)
        arrange_imposed_range pitem, dim, pitem.firstkid, -1, pitem.margins[dim], pitem.size[dim]
      end

      private def arrange_imposed_squeezed_range(pitem, dim, start_kid, end_kid, offset, space)
        wdim = dim + 2

        kid = start_kid
        while kid != end_kid
          pkid = item_ptr kid

          flags = (pkid.flags & ITEM_LAYOUT_MASK) >> dim

          min_size = [0, space - pkid.margins[dim] - pkid.margins[wdim]].max
          case (flags & HFILL)
          when HCENTER
            pkid.size[dim] = [pkid.size[dim], min_size].min
            pkid.margins[dim] += ((space - pkid.size[dim]) / 2 - pkid.margins[wdim]).to_i
          when RIGHT
            pkid.size[dim] = [pkid.size[dim], min_size].min
            pkid.margins[dim] = space - pkid.size[dim] - pkid.margins[wdim]
          when HFILL
            pkid.size[dim] = min_size
          else
            pkid.size[dim] = [pkid.size[dim], min_size].min
          end
          pkid.margins[dim] += offset

          kid = next_sibling kid
        end
      end

      private def arrange_imposed_squeezed(pitem, dim)
        arrange_imposed_squeezed_range pitem, dim, pitem.firstkid, -1, pitem.margins[dim], pitem.size[dim]
      end

      private def arrange_wrapped_imposed_squeezed(pitem, dim)
        wdim = dim + 2

        offset = pitem.margins[dim]

        need_size = 0
        kid = pitem.firstkid
        start_kid = kid
        while kid >= 0
          pkid = item_ptr kid

          if (pkid.flags & BREAK) != 0
            arrange_imposed_squeezed_range pitem, dim, start_kid, kid, offset, need_size
            offset += need_size
            start_kid = kid
            # new line
            need_size = 0
          end

          kidsize = full_item_width pkid, dim
          need_size = [need_size, kidsize].max
          kid = next_sibling kid
        end

        arrange_imposed_squeezed_range pitem, dim, start_kid, -1, offset, need_size
        offset += need_size
        offset
      end

      private def arrange(item, dim)
        pitem = item_ptr item

        case (pitem.flags & ITEM_BOX_MODEL_MASK)
        when COLUMN | WRAP
          if dim != 0
            arrange_stacked pitem, 1, true
            offset = arrange_wrapped_imposed_squeezed pitem, 0
            pitem.size[0] = offset - pitem.margins[0]
          end
        when ROW | WRAP
          if dim == 0
            arrange_stacked pitem, 0, true
          else
            arrange_wrapped_imposed_squeezed pitem, 1
          end
        when COLUMN, ROW
          if (pitem.flags & 1) == dim
            arrange_stacked pitem, dim, false
          else
            arrange_imposed_squeezed pitem, dim
          end
        else
          arrange_imposed pitem, dim
        end

        kid = first_child item
        while kid >= 0
          arrange kid, dim
          kid = next_sibling kid
        end
      end

      private def compare_items(item1, item2)
        (item1.flags & ITEM_COMPARE_MASK) == (item2.flags & ITEM_COMPARE_MASK)
      end

      private def map_items(item1, item2)
        pitem1 = last_item_ptr item1
        return false if item2 == -1

        pitem2 = item_ptr item2
        return false unless compare_items(pitem1, pitem2)

        count = 0
        failed = 0
        kid1 = pitem1.firstkid
        kid2 = pitem2.firstkid

        while kid1 != -1
          pkid1 = last_item_ptr kid1
          count += 1

          unless map_items kid1, kid2
            failed = count
            break
          end

          kid1 = pkid1.nextitem
          if kid2 != -1
            kid2 = item_ptr(kid2).nextitem
          end
        end

        if (count != 0) && (failed == 1)
          return false
        end
        @item_map[item1] = item2
        true
      end

      def recover_item(olditem)
        raise unless olditem >= -1
        raise unless olditem < @last_count
        return -1 if olditem == -1
        @item_map[olditem]
      end

      def remap_item(olditem, newitem)
        raise unless olditem >= 0
        raise unless olditem < @last_count
        raise unless newitem >= -1
        raise unless newitem < @count
        @item_map[olditem] = newitem
      end

      def end_layout
        raise unless @stage == :layout

        if @count != 0
          compute_size 0, 0
          arrange 0, 0
          compute_size 0, 1
          arrange 0, 1

          if @last_count != 0
            map_items 0, 0
          end
        end

        validate_state_items
        if @count != 0
          update_hot_item
        end

        @stage = :post_layout
      end

      def rect(item)
        pitem = item_ptr item
        Rect.new pitem.margins[0], pitem.margins[1], pitem.size[0], pitem.size[1]
      end

      def first_child(item)
        item_ptr(item).firstkid
      end

      def next_sibling(item)
        item_ptr(item).nextitem
      end

      def alloc_handle(item, size)
        pitem = item_ptr item
        raise if pitem.handle
        raise unless @datasize + size <= @buffer_capacity
        pitem.handle = @data[@datasize]
        pitem.flags |= ITEM_DATA
        @datasize += size
        pitem.handle
      end

      def set_handle(item, handle)
        pitem = item_ptr item
        raise if pitem.handle
        pitem.handle = handle
      end

      def get_handle(item)
        item_ptr(item).handle
      end

      def set_handler(&handler)
        @handler = handler
      end

      def handler
        @handler
      end

      def set_events(item, flags)
        pitem = item_ptr item
        pitem.flags &= ~ITEM_EVENT_MASK
        pitem.flags |= flags & ITEM_EVENT_MASK
      end

      def events(item)
        item_ptr(item).flags & ITEM_EVENT_MASK
      end

      def set_flags(item)
        pitem = item_ptr item
        pitem.flags &= ~USERMASK
        pitem.flags |= flags & USERMASK
      end

      def flags(item)
        item_ptr(item).flags & USERMASK
      end

      def contains?(item, x, y)
        r = rect item
        x -= r.x
        y -= r.y

        ((x >= 0) && (y >= 0) && (x < r.w) && (y < r.h))
      end

      def find_item(item, x, y, flags, mask)
        pitem = item_ptr item
        return -1 if (pitem.flags & ITEM_FROZEN) != 0
        if contains?(item, x, y)
          best_hit = -1
          kid = first_child item
          while kid >= 0
            hit = find_item kid, x, y, flags, mask
            best_hit = hit if hit >= 0
            kid = next_sibling kid
          end
          return best_hit if best_hit >= 0
          if ((mask == ANY) && ((flags == ANY) || ((pitem.flags & flags) != 0))) ||
             ((pitem.flags & flags) == mask)
            return item
          end
        end
        -1
      end

      def update_hot_item
        return if @count <= 0
        @hot_item = find_item 0, @cursor.x, @cursor.y, ANY_MOUSE_INPUT, ANY
      end

      def clicks
        @clicks
      end

      def process(timestamp)
        raise if @stage == :layout

        update_hot_item if @stage == :process
        @stage = :process

        if @count == 0
          clear_input_events
          return
        end

        hot_item = @last_hot_item
        active_item = @active_item
        focus_item = @focus_item

        if focus_item >= 0
          @eventcount.times do |i|
            e = @events[i]
            @active_key = e.key
            @active_modifier = e.mod
            notify_item focus_item, e.event
          end
        else
          @focus_item = -1
        end

        if (@scroll.x != 0) || (@scroll.y != 0)
          scroll_item = find_item 0, @cursor.x, @cursor.y, SCROLL, ANY
          if scroll_item >= 0
            notify_item scroll_item, SCROLL
          end
        end

        clear_input_events

        hot = @hot_item

        #p [@state, hot, hot_item]
        case @state
        when :capture
          if !button(0)
            if active_item >= 0
              @active_modifier = @active_button_modifier
              notify_item active_item, BUTTON0_UP
              if active_item == hot
                notify_item active_item, BUTTON0_HOT_UP
              end
            end
            active_item = -1
            @state = :idle
          else
            if active_item >= 0
              @active_modifier = @active_button_modifier
              notify_item active_item, BUTTON0_CAPTURE
            end

            hot_item = (hot == active_item) ? hot : -1
          end
        else # :idle
          @start_cursor = @cursor.dup
          if button(0)
            hot_item = -1
            active_item = hot

            if active_item != focus_item
              focus_item = -1
              @focus_item = -1
            end

            if active_item >= 0
              if ((timestamp - @last_click_timestamp) > CLICK_THRESHOLD) ||
                 (@last_click_item != active_item)
                @clicks = 0
              end
              @clicks += 1

              @last_click_timestamp = timestamp
              @last_click_item = active_item
              @active_modifier = @active_button_modifier
              notify_item active_item, BUTTON0_DOWN
            end
            @state = :capture
          elsif button(2) && !last_button(2)
            hot_item = -1
            hot = find_item 0, @cursor.x, @cursor.y, BUTTON2_DOWN, ANY
            if hot >= 0
              @active_modifier = @active_button_modifier
              notify_item hot, BUTTON2_DOWN
            end
          else
            hot_item = hot
          end
        end

        @last_cursor = @cursor.dup
        @last_hot_item = hot_item
        @active_item = active_item

        @last_timestamp = timestamp
        @last_buttons = @buttons
      end

      private def is_active?(item)
        @active_item == item
      end

      private def is_hot?(item)
        @last_hot_item == item
      end

      private def is_focused?(item)
        @focus_item == item
      end

      def state(item)
        pitem = item_ptr item
        return FROZEN if (pitem.flags & ITEM_FROZEN) != 0
        if is_focused? item
          return ACTIVE if (pitem.flags & (KEY_DOWN | CHAR | KEY_UP)) != 0
        end
        if is_active? item
          return ACTIVE if (pitem.flags & (BUTTON0_CAPTURE | BUTTON0_UP)) != 0
          return ACTIVE if ((pitem.flags & BUTTON0_HOT_UP) != 0) && is_hot?(item)
          return COLD
        elsif is_hot? item
          return HOT
        end
        COLD
      end

      def create_layout
        begin_layout
        yield self
        end_layout
      end
    end
  end
end
