#ifndef CPT_SCORER_HPP
#define CPT_SCORER_HPP

#include <cstdint>
#include <vector>

class Scorer
{
public:
    Scorer();
    Scorer(std::size_t size);

    int get_score(std::size_t index) const;
    void update(std::size_t index);

private:
    std::vector<int> m_data;
};

#endif
