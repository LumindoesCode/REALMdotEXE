custom_cart = cartridge_data("ooo_cart", "ooo custom", "oh shit")

function custom_cart.Create(obj)
    set_var(obj, "cart", 14459)
    set_var(obj, "shop_cost", 0)
end

register_data(custom_cart)
