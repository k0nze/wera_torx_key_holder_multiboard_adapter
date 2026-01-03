include <multiboard.scad>

$fn = $preview ? 32 : 64;


holder_width = 58.9;
holder_depth = 25.3;
holder_height = 5;

holder_bottom_length = 51.6;

holder_radius_0 = 17.25 / 2;
holder_radius_0_length = 22.7;

holder_radius_1 = 11.8/2;

holder_radius_2 = 13.3/2;

holder_radius_3 = 11.2/2;

holder_radius_4 = 2/2;

holder_neg_radius_0 = 3;

holder_latch_width = 9;
holder_latch_depth = 3.5;

holder_latch_x_offset = 4;

holder_sticker_depth = 1.2;
holder_sticker_width = 17;


multiboard_holder_height = 20;
multiboard_holder_width = holder_width+2;
multiboard_holder_back_offset = 5.4;

multiboard_holder_radius = 20/2;

module neg_radius(h, r, start_angle=0, stop_angle=90, offset=1) {
    intersection() {
        translate([0,0,0]) {
            rotate([0,0,180]) {
                difference() {
                    cube([2*r+offset,2*r+offset,h], center=true);
                    cylinder(h=h+1, r1=r, r2=r, center=true);

                }
            }
        }

        translate([0,0,-(h+1)/2]) {
            rotate([0,0,start_angle]) {
                rotate_extrude(angle=stop_angle-start_angle) {
                    polygon([[0,0], [r+2*offset,0], [r+2*offset,h+1], [0,h+1]]);
                }
            }
        }
    }
}

module wera_footprint(h) {
    holder_height = h;
    union() {
        hull() {
            // left bottom
            translate([holder_radius_0, 0, 0]) {
                cylinder(h=holder_height, r1=holder_radius_0, r2=holder_radius_0, center=true);
            }

            translate([(holder_radius_0_length - holder_radius_0)/2+holder_radius_0, 0, 0]) {
                cube([holder_radius_0_length - holder_radius_0, holder_radius_0*2, holder_height], center=true);
            }

            // right bottom
            translate([holder_radius_1 + holder_bottom_length-holder_radius_1*2, 0, 0]) {
                cylinder(h=holder_height, r1=holder_radius_1, r2=holder_radius_1, center=true);
            }
        } // hull end

        translate([holder_radius_2 + holder_width - holder_radius_2*2,-holder_radius_2,0]) {
            cylinder(h=holder_height, r1=holder_radius_2, r2=holder_radius_2, center=true);
        }


        hull() {
            translate([holder_radius_3 + holder_bottom_length - holder_radius_3*2, -holder_radius_2*2 +1.5 ,0]) {
                cylinder(h=holder_height, r1=holder_radius_3, r2=holder_radius_3, center=true);
            }

            // left bottom
            translate([holder_radius_0, 0, 0]) {
                cylinder(h=holder_height, r1=holder_radius_0, r2=holder_radius_0, center=true);
            }

            translate([18.7, -(17.4-holder_radius_4-1.5), 0]) {
                cylinder(h=holder_height, r1=holder_radius_4, r2=holder_radius_4, center=true);
            }

            translate([holder_latch_width/2 + holder_latch_x_offset, -(holder_latch_depth/2 + holder_radius_0), 0]) {
                cube([holder_latch_width, holder_latch_depth, holder_height], center=true);
            }
        }

        // neg radius back
        translate([holder_bottom_length+2.5, 2.75, 0]) {
            rotate([0,0,180]) {
                neg_radius(h=holder_height+2, r=holder_neg_radius_0, start_angle=15, stop_angle=70);
            }
        }

        // neg radius front
        translate([holder_bottom_length+1.75, -(holder_neg_radius_0+holder_radius_2*2-0.15), 0]) {
            rotate([0,0,90]) {
                neg_radius(h=holder_height+2, r=holder_neg_radius_0, start_angle=10, stop_angle=60);
            }
        }

        rotate([0,0,-3.35]) {
            translate([holder_sticker_width/2 + 28.3, holder_sticker_depth/2-15.85, 0]) {
                cube([holder_sticker_width, holder_sticker_depth, holder_height], center=true);
            }
        }
    }
}

module multiboard_holder_footprint(h) {
    multiboard_holder_height = h;
    y_front_offset = -8.5;
    hull() {
        // back left
        translate([multiboard_holder_radius-1,3,-multiboard_holder_height/2]) {
            cylinder(h=multiboard_holder_height, r1=multiboard_holder_radius, r2=multiboard_holder_radius);
        }

        // front left
        translate([multiboard_holder_radius-1, y_front_offset, -multiboard_holder_height/2]) {
            cylinder(h=multiboard_holder_height, r1=multiboard_holder_radius, r2=multiboard_holder_radius);
        }

        // back right
        translate([multiboard_holder_width - multiboard_holder_radius - 1,3,-multiboard_holder_height/2]) {
            cylinder(h=multiboard_holder_height, r1=multiboard_holder_radius, r2=multiboard_holder_radius);
        }

        // front right
        translate([multiboard_holder_width - multiboard_holder_radius - 1, y_front_offset,-multiboard_holder_height/2]) {
            cylinder(h=multiboard_holder_height, r1=multiboard_holder_radius, r2=multiboard_holder_radius);
        }
    }
}

union() {
    difference() {
        multiboard_holder_footprint(multiboard_holder_height);

        wera_footprint(h=multiboard_holder_height+2);

        // front cutout
        translate([10+22,-15,0]) {
            cube([28, 20, multiboard_holder_height+2], center=true);
        }
    } // end difference

    intersection() {
        // left inner step
        translate([4.5, -5, -(multiboard_holder_height/2-2.5)]) {
            cube([11, holder_depth+5.4*2, 5], center=true);
        }

        multiboard_holder_footprint(multiboard_holder_height);
    }

    // right inner step
    intersection() {
        difference() {
            translate([multiboard_holder_width-4.5, -5, -(multiboard_holder_height/2-(5+6.4)/2)]) {
                cube([7, holder_depth+5.4*2, 5+6.4], center=true);
            }

            translate([multiboard_holder_width-31,15,-3.57]) {
                rotate([90,0,0]) {
                    linear_extrude(height=40) {
                        polygon([[0,5], [0,0], [30,5]]);
                    }
                }
            }

        }
        multiboard_holder_footprint(multiboard_holder_height);
    }

    translate([multiboard_holder_width/2,16,0]) {
        rotate([90,0,0]) {
            mb_snap_inner_octagon(height=9);
        }
    }
} // end union

