
fn generate_svg_(token_id: u256) -> Array<felt252> {
    let mut svg = ArrayTrait::new();
    let mut num: u256 = token_id;

    svg.append('<svg xmlns="http://www.w3.org/');
    svg.append('2000/svg" viewBox="-0.2 -0.2');
    svg.append(' ' * 256 + WIDTH_STR);
    svg.append('.4');
    svg.append(' ' * 256 + HEIGHT_STR);
    svg.append('.4" stroke="#1B2D37" stroke');
    svg.append('-width=".4" stroke-linecap="');
    svg.append('round">');

    svg.append('<rect width="');
    svg.append(WIDTH_STR);
    svg.append('" height="');
    svg.append(HEIGHT_STR);
    svg.append('" fill="');
    svg.append(get_bg_color(token_id.high));
    svg.append('" />');

    let mut col = 2_u8;
    loop {
        if (col > WIDTH - 1) {
            break;
        }
        let mut row = 1_u8;
        loop {
            if (row > HEIGHT - 1) {
                break;
            }
            let choice = num % 4;
            num = num / 4;

            if (choice == 0) {
                add_line(ref svg, row - 1, col - 1, row, col);
            };
            if (choice == 1) {
                add_line(ref svg, row, col - 1, row - 1, col);
            };
            if (choice == 2) {
                add_line(ref svg, row, col - 1, row, col);
            };
            if (choice == 3) {
                add_line(ref svg, row, col, row - 1, col);
            };
            add_line(ref svg, col, row, col - 1, row);
            row += 1;
        };
        col += 1;
    };
    svg.append('</svg>');
    svg.append('<!--N1C3R4-L485-->');

    svg
}
