
const SSD1306 = "libssd1306_i2c"
const ssd1306_err_t = Ptr{Cvoid}
const ssd1306_framebuffer_t = Ptr{Cvoid}
const ssd1306_i2c_t = Ptr{Cvoid}

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

function main()
    oled = ssd1306_i2c_open("/dev/i2c-1", 0x3c, 128, 64, C_NULL)
    err = ssd1306_i2c_display_initialize(oled)
    ssd1306_i2c_display_clear(oled)
    errp = ssd1306_err_create()
    fbp = ssd1306_framebuffer_create(128, 64, errp)
    err = ssd1306_framebuffer_draw_line(fbp, 0, 0, 127, 63, true)
    ssd1306_i2c_display_update(oled, fbp)
    sleep(5)
    ssd1306_framebuffer_destroy(fbp)
    ssd1306_i2c_close(oled)
    ssd1306_err_destroy(errp)
end

main()
