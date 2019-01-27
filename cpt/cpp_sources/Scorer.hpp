#ifndef CPT_SCORER_HPP
#define CPT_SCORER_HPP

#include <vector>

class Scorer
{
public:
    Scorer();
    Scorer(std::size_t size);

    int get_score(std::size_t index) const;

    void update(std::size_t index);

    bool predictable() const;

    int get_best_prediction() const;

private:
    std::vector<int> m_data;
};

#endif
