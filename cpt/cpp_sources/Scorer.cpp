#include "Scorer.hpp"

Scorer::Scorer()
{}

Scorer::Scorer(std::size_t size)
: m_data(size)
{}

int Scorer::get_score(std::size_t index) const
{
    return m_data[index];
}

void Scorer::update(std::size_t index)
{
    m_data[index]++;
}
