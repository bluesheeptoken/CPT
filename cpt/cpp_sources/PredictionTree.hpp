#ifndef CPT_PREDICTIONTREE_HPP
#define CPT_PREDICTIONTREE_HPP

#include <vector>
#include <map>

class PredictionTree
{
public:
    PredictionTree();
    PredictionTree(const int incomingTransition, PredictionTree* parent);

    PredictionTree* addChild(const int element);

    int m_incomingTransition;
    PredictionTree* m_parent;

private:
    std::map<int, PredictionTree> m_children;
};

#endif
