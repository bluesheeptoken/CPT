#include "bitset.hpp"
#include <algorithm>

Bitset::Bitset(std::size_t size)
: m_data(size/8 + (size%8 != 0)), m_size(size)
{}

std::size_t Bitset::size() const
{
    return m_size;
}

bool Bitset::operator[](std::size_t index) const
{
    return m_data[index/8] >> index%8 & 1;
}
void Bitset::add(std::size_t index)
{
    m_data[index/8] |= 1 << index%8;
}

Bitset& Bitset::inter(const Bitset& other)
{
    std::size_t minimal_size = std::min(m_data.size(), other.m_data.size());
    for (std::size_t i = 0; i < minimal_size; i++)
        m_data[i] &= other.m_data[i];
    m_size = std::min(m_size, other.m_size);
    m_data.resize(minimal_size);
    return *this;
}

void Bitset::clear()
{
    m_data.assign(m_data.size(), 0);
}
