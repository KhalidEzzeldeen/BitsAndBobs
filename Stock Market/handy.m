for i=1:10
    output = meta_Market(output);
    input.buy_price=output.buy_price;
    input.sell_price=output.sell_price
    output = Market(input)
end