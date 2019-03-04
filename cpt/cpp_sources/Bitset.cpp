#include "Bitset.hpp"
#include <algorithm>
#include <bitset>


Bitset::Bitset()
{}

Bitset::Bitset(std::size_t size)
: m_data(size/8 + (size%8 != 0)), m_size(size)
{}

Bitset::Bitset(const Bitset& other)
: m_data(other.m_data), m_size(other.m_size)
{}

Bitset::Bitset(const std::vector<std::uint8_t>& data, std::size_t size)
: m_data(data), m_size(size)
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

float Bitset::compute_frequency() const
{
    std::size_t occurrences = 0;
    for (std::size_t i = 0; i < m_data.size(); i++)
        occurrences += std::bitset<8>(m_data[i]).count();
    return static_cast<float>(occurrences) / m_size;
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

void Bitset::resize(std::size_t size)
{
    m_data.resize(size/8 + (size%8 != 0));
    m_size = size;
}
