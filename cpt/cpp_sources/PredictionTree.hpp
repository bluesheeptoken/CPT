#ifndef CPT_SCORER_HPP
#define CPT_SCORER_HPP

#include <vector>
#include <map>

class PredictionTree
{
public:
    PredictionTree();
    PredictionTree(const int incomingTransition);
    PredictionTree(const int incomingTransition, PredictionTree* parent);

    PredictionTree* getChild(const int element) const;
    PredictionTree* addChild(const int element);

    int m_incomingTransition;

private:
    std::map<int, PredictionTree*> m_children;
    PredictionTree* m_parent;
};

#endif
