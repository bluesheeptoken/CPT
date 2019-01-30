#include "PredictionTree.hpp"

PredictionTree::PredictionTree()
{}

PredictionTree::PredictionTree(const int incomingTransition)
: m_incomingTransition(incomingTransition), m_parent(nullptr)
{}

PredictionTree::PredictionTree(const int incomingTransition, PredictionTree* parent)
: m_incomingTransition(incomingTransition), m_parent(parent)
{}

PredictionTree* PredictionTree::getChild(const int element) const
{
    if (m_children.find(element) != m_children.end())
        return m_children.at(element);
    else
        return nullptr;
}

PredictionTree* PredictionTree::addChild(const int element)
{
    if (m_children.find(element) == m_children.end())
        m_children[element] = new PredictionTree(element, this);
    return m_children[element];
}
