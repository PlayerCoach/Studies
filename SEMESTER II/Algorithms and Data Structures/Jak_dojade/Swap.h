#pragma once

template<typename type>
void Swap(type& a, type& b) {
    type temp = static_cast<type&&>(a);
    a = static_cast<type&&>(b);
    b = static_cast<type&&>(temp);
}