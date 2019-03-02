#ifndef CPT_PREDICTIONTREE_HPP
#define CPT_PREDICTIONTREE_HPP

#include <vector>
#include <map>

typedef std::size_t Node;

class PredictionTree
{
public:
    PredictionTree();
    PredictionTree(Node nextNode, const std::vector<int>& incoming, const std::vector<int>& parent, const std::vector<std::map<int, Node>>& children);

    Node addChild(Node parent, int transition);

    int getTransition(Node node) const { return m_incoming[node]; }

    Node getParent(Node node) const { return m_parent[node]; }

    Node get_next_node() const { return m_nextNode; };

    const std::vector<int>& get_incoming() const { return m_incoming; };
    const std::vector<int>& get_parent() const { return m_parent; };
    const std::vector<std::map<int, Node>>& get_children() const { return m_children; };

private:
    Node m_nextNode;

    std::vector<int> m_incoming;
    std::vector<int> m_parent;
    std::vector<std::map<int, Node>> m_children;
};

#endif
