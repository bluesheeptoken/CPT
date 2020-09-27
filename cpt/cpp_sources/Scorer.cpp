#include "Scorer.hpp"
#include <algorithm>

namespace
{
    struct CountingIterator
    {
        typedef int value_type;
        typedef int difference_type;
        typedef const int& reference;
        typedef const int* pointer;
        typedef std::input_iterator_tag iterator_category;

        CountingIterator() = default;
        explicit CountingIterator(int value) : value(value) {}

        reference operator*() const { return value; }

        CountingIterator& operator++() { ++value; return *this; }
        CountingIterator operator++(int) { return CountingIterator(value++); }

        bool operator==(const CountingIterator& rhs) const { return value == rhs.value; }
        bool operator!=(const CountingIterator& rhs) const { return value != rhs.value; }

    private:
        int value;
    };
}

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

std::vector<int> Scorer::get_best_k_predictions(std::size_t k) const
{
    std::vector<int> best_predictions(std::min(k, m_data.size()));

    std::partial_sort_copy(CountingIterator(0), CountingIterator(m_data.size()),
        best_predictions.begin(), best_predictions.end(),
        [this](int x, int y) { return m_data[x] > m_data[y]; });

    return best_predictions;
}
