#ifndef CPT_PREDICTIONTREE_HPP
#define CPT_PREDICTIONTREE_HPP

#include <vector>
#include <map>

class PredictionTree
{
public:
    PredictionTree();

    std::size_t getRoot() const { return 0; }

    std::size_t addChild(std::size_t parent, int transition);

    int getTransition(std::size_t node) const { return m_incoming[node]; }

    std::size_t getParent(std::size_t node) const { return m_parent[node]; }

private:
    std::size_t m_nextNode;

    std::vector<int> m_incoming;
    std::vector<int> m_parent;
    std::vector<std::map<int, std::size_t>> m_children;
};

#endif
