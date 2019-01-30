#include "PredictionTree.hpp"

PredictionTree::PredictionTree()
{}

PredictionTree::PredictionTree(const int incomingTransition, PredictionTree* parent)
: m_incomingTransition(incomingTransition), m_parent(parent)
{}

PredictionTree* PredictionTree::addChild(const int element)
{
    if (m_children.find(element) == m_children.end())
        m_children[element] = PredictionTree(element, this);
    return &m_children[element];
}
