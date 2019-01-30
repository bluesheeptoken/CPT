#include "PredictionTree.hpp"

PredictionTree::PredictionTree()
: m_nextNode(1), m_incoming(1, -1), m_parent(1, 0), m_children(1)
{}

std::size_t PredictionTree::addChild(std::size_t parent, int element)
{
    auto insertion = m_children[parent].insert(std::make_pair(element, m_nextNode));
    if(insertion.second) // the insertion took place
    {
        m_incoming.push_back(element);
        m_parent.push_back(parent);
        m_children.push_back(std::map<int, std::size_t>());
        return m_nextNode++;
    }
    else
        return insertion.first->second;
}
