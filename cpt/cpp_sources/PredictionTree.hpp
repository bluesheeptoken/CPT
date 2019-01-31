#ifndef CPT_PREDICTIONTREE_HPP
#define CPT_PREDICTIONTREE_HPP

#include <vector>
#include <map>

typedef std::size_t Node;

class PredictionTree
{
public:
    PredictionTree();

    Node addChild(Node parent, int transition);

    int getTransition(Node node) const { return m_incoming[node]; }

    Node getParent(Node node) const { return m_parent[node]; }

private:
    Node m_nextNode;

    std::vector<int> m_incoming;
    std::vector<int> m_parent;
    std::vector<std::map<int, Node>> m_children;
};

#endif
