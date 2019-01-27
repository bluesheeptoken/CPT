#include "Scorer.hpp"
#include <algorithm>

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

bool Scorer::predictable() const
{
    for(std::vector<int>::const_iterator it = m_data.begin(); it != m_data.end(); ++it)
        if(0 < *it)
            return true;
    return false;
}

int Scorer::get_best_prediction() const
{
    return std::distance(m_data.begin(), std::max_element(m_data.begin(), m_data.end()));
}
