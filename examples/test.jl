
const SSD1306 = "libssd1306_i2c"
const ssd1306_err_t = Ptr{Cvoid}
const ssd1306_framebuffer_t = Ptr{Cvoid}
const ssd1306_i2c_t = Ptr{Cvoid}

const SSD1306_FONT_DEFAULT = 0
const SSD1306_FONT_VERA_BOLD = 1
const SSD1306_FONT_VERA_ITALIC = 2 
const SSD1306_FONT_VERA_BOLDITALIC = 3   
const SSD1306_FONT_FREEMONO = 4
const SSD1306_FONT_FREEMONO_BOLD = 5     
const SSD1306_FONT_FREEMONO_ITALIC = 6  
const SSD1306_FONT_FREEMONO_BOLDITALIC = 7
const SSD1306_FONT_CUSTOM = 8

const ssd1306_fontface_t = Cint

# struct ssd1306_framebuffer_box_t
#     top::UInt8
#     left::UInt8
#     bottom::UInt8
#     right::UInt8
# end

const SSD1306_OPT_FONT_FILE = 0

# Just font file for now
struct ssd1306_graphics_options_t
    type::Int32
    font_file::Cstring
end

ssd1306_err_create() = @ccall SSD1306.ssd1306_err_create(C_NULL::Ptr{Cvoid})::ssd1306_err_t
ssd1306_framebuffer_create(width, height, err)::ssd1306_framebuffer_t = @ccall SSD1306.ssd1306_framebuffer_create(width::UInt8, height::UInt8, err::Ptr{Cvoid})::Ptr{Cvoid}
ssd1306_framebuffer_draw_line(fbp, x0, y0, x1, y1, color)::Int = @ccall SSD1306.ssd1306_framebuffer_draw_line(fbp::Ptr{Cvoid}, x0::UInt8, y0::UInt8, x1::UInt8, y1::UInt8, color::Bool)::Cint
ssd1306_err_destroy(err) = @ccall SSD1306.ssd1306_err_destroy(err::ssd1306_err_t)::Cvoid
ssd1306_i2c_display_update(oled::ssd1306_i2c_t, fbp::ssd1306_framebuffer_t) = @ccall SSD1306.ssd1306_i2c_display_update(oled::Ptr{Cvoid}, fbp::Ptr{Cvoid})::Cint
ssd1306_i2c_open(filename, daddr, width, height, logerr)::ssd1306_i2c_t = @ccall SSD1306.ssd1306_i2c_open(filename::Cstring, daddr::UInt8, width::UInt8, height::UInt8, logerr::Ptr{Cvoid})::Ptr{Cvoid}
ssd1306_i2c_display_initialize(oled::ssd1306_i2c_t) = @ccall SSD1306.ssd1306_i2c_display_initialize(oled::Ptr{Cvoid})::Cint
ssd1306_i2c_display_clear(oled::ssd1306_i2c_t) = @ccall SSD1306.ssd1306_i2c_display_clear(oled::Ptr{Cvoid})::Cint
ssd1306_framebuffer_destroy(fbp::ssd1306_framebuffer_t) = @ccall SSD1306.ssd1306_framebuffer_destroy(fbp::Ptr{Cvoid})::Cvoid
ssd1306_i2c_close(oled::ssd1306_i2c_t) = @ccall SSD1306.ssd1306_i2c_close(oled::Ptr{Cvoid})::Cvoid
ssd1306_framebuffer_draw_text(fbp, str, x, y, fontface, font_size) = @ccall SSD1306.ssd1306_framebuffer_draw_text(fbp::Ptr{Cvoid}, str::Cstring, 0::Csize_t, x::UInt8, y::UInt8, fontface::Cint, font_size::UInt8, C_NULL::Ptr{Cvoid})::Cint
ssd1306_framebuffer_clear(fbp) = @ccall SSD1306.ssd1306_framebuffer_clear(fbp::Ptr{Cvoid})::Cint
ssd1306_framebuffer_draw_text_extra(fbp, str, x, y, fontface, font_size, opts) = @ccall SSD1306.ssd1306_framebuffer_draw_text_extra(fbp::Ptr{Cvoid}, str::Cstring, 0::Csize_t, x::UInt8, y::UInt8, fontface::Cint, font_size::UInt8, opts::Ptr{Cvoid}, 1::Csize_t, C_NULL::Ptr{Cvoid})::Cint

# ssize_t ssd1306_framebuffer_draw_text_extra(ssd1306_framebuffer_t *fbp,
#                 const char *str, size_t slen,
#                 uint8_t x, uint8_t y,
#                 ssd1306_fontface_t fontface, uint8_t font_size,
#                 const ssd1306_graphics_options_t *opts, size_t num_opts, ssd1306_framebuffer_box_t *bounding_box);

function main()
    oled = ssd1306_i2c_open("/dev/i2c-1", 0x3c, 128, 64, C_NULL)
    err = ssd1306_i2c_display_initialize(oled)
    ssd1306_i2c_display_clear(oled)
    errp = ssd1306_err_create()
    fbp = ssd1306_framebuffer_create(128, 64, errp)
    # err = ssd1306_framebuffer_draw_line(fbp, 0, 0, 127, 63, true)
    # ssd1306_framebuffer_draw_text(fbp, "01234 - TEST", 0, 0, SSD1306_FONT_DEFAULT, 4);
    # font = "/home/ian/slkscr.ttf"
    # ptr = pointer_from_objref(font)
    opts = ssd1306_graphics_options_t(SSD1306_OPT_FONT_FILE, Base.unsafe_convert(Cstring, "/home/ian/slkscr.ttf"))
    ssd1306_framebuffer_draw_text_extra(fbp, "01234 - TEST", 1, 2, SSD1306_FONT_CUSTOM, 2, Ref(opts))
    ssd1306_i2c_display_update(oled, fbp)
    sleep(5)
    ssd1306_framebuffer_destroy(fbp)
    ssd1306_i2c_close(oled)
    ssd1306_err_destroy(errp)
end

main()

