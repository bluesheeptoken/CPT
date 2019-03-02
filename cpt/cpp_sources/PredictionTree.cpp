#include "PredictionTree.hpp"

PredictionTree::PredictionTree()
: m_nextNode(1), m_incoming(1, -1), m_parent(1, 0), m_children(1) // -1 is the unknown index
{}

PredictionTree::PredictionTree(Node nextNode, const std::vector<int>& incoming, const std::vector<int>& parent, const std::vector<std::map<int, Node>>& children)
: m_nextNode(nextNode), m_incoming(incoming), m_parent(parent), m_children(children)
{}

Node PredictionTree::addChild(Node parent, int element)
{
    auto insertion = m_children[parent].insert(std::make_pair(element, m_nextNode));

    if(insertion.second) // the insertion took place
    {
        m_nextNode++;
        m_incoming.push_back(element);
        m_parent.push_back(parent);
        m_children.push_back(std::map<int, Node>());
    }

    return insertion.first->second;
}
