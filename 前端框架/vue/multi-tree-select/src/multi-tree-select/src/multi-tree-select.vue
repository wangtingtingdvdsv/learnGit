<template>
    <div class="x-tree-select x-multi-tree-select" >
        <div class="x-tree-select-input-wrap" @click="showDropDown = !showDropDown">
            <i v-if="allowClear && !disabled" class="x-icon x-tree-select-input-icon x-icon-android-close" @click.stop="clearAll"></i>
            <div class="x-tree-select-input x-tree-select-input-content" v-if="hasSelected" :class="{'is-disabled' : disabled}">
                <span v-for="item in inputContent" style="margin-right:8px" :key="item.id">{{item.name}}</span>
            </div>
            <div class="x-tree-select-input" :class="{'is-disabled' : disabled}" v-else>
                <span class="no-select">请选择</span>
            </div>
        </div>
        <transition name="x-slide-up">
            <div class="x-tree-select-item-wrap" v-show="showDropDown && !disabled">
                <slot name="header"></slot>
                <div class="x-tree-select-item-level">
                    <div class="x-tree-select-item" v-for="(level, levelIndex) in levelData" :key="levelIndex">
                        <template v-if="levelIndex >= 0">
                            <ul>
                                <li class="x-tree-select-item-search" v-if="allowSearch">
                                    <i class="x-icon x-tree-select-input-icon x-tree-select-item-input-icon x-icon-android-close" @click="clearSug( level )"></i>
                                    <input class="x-input"
                                        type="text"
                                        :placeholder="'搜索' + fieldTexts[level.branchDepth]"
                                        v-model="level.sugText">
                                </li>

                                <li @click="checkItemAll(level, level, levelIndex)" v-if="(level.sugText||'').trim() ==='' " class="checkbox-all x-tree-select-item-li" :class="{'active': level.hoverKey === 'all'}" @mouseenter="hoverForAll( level, levelIndex)">
                                    <v-checkbox :val.sync="level.selected">{{'全部' + fieldTexts[level.branchDepth]}}</v-checkbox>
                                    <i v-if="!hideSubListArrow(levelIndex)" class="x-icon x-icon-chevron-right x-tree-select-right-icon"></i>
                                </li>
                                <template v-if="showListView( level )">
                                    <li v-for="item in filterList(level.list, ([level.sugText]+'').trim() )" :key="item[keyName]" class="x-tree-select-item-li" :class="{'active': level.hoverKey === item[keyName]}" @click="checkItem(level, item, levelIndex)" @mouseenter="hover( item, levelIndex)">
                                        <v-checkbox :val.sync="item.selected">{{item[textName]}}</v-checkbox>
                                        <i v-if="levelIndex !== fieldsLen " class="x-icon x-icon-chevron-right x-tree-select-right-icon"></i>
                                    </li>
                                </template>
                            </ul>
                        </template>
                    </div>
                </div>
                <slot name="footer"></slot>
            </div>
        </transition>
    </div>
</template>

<script>
import vCheckbox from './tree-select-checkbox.vue';
import { concatMultiList, filterList, travelUp, travelDown } from './util.js';
import mixin from './mixin.js';
const CHECKBOX_UNCHECKED = 0;
const CHECKBOX_CHECKED = 1;
const CHECKBOX_INDETERMINATE = 2; // 部分选中
const Event_INITED = 'inited';
const Event_Select_With_Path = 'change';
const Event_Select_Value = 'input';
const EVERY_LEVEL_INDEX = 'INDEX';
const EVERY_LEVEL_KEY = 'KEY';
const LAST_LEVEL = 'LAST';
const ALL_LEVEL = 'DETAIL';

let exposeDataEventTimer = null;

// 对比一列数据的 selected 状态，来得出结果作为其 parent 的状态
const compareWithSibling = (list) => {
    if (list) {
        let keys = Object.keys(list);
        if (keys.length > 1) {// 有很多项
            let firstKeySelectStatus = list[keys[0]].selected;// 取出第一项
            if (keys.some(key => {// 发现有跟第一项不一样的值
                return list[key].selected !== firstKeySelectStatus;
            })) {
                return CHECKBOX_INDETERMINATE;// 部分选中
            }
            else {
                return firstKeySelectStatus;
            }
        }
        else if (keys.length === 1) {// 只有一项，那就直接拿这一项的状态
            return list[keys[0]].selected;
        }
        else { // list 可能为空对象 {}
            return CHECKBOX_UNCHECKED;
        }
    }
    else { // 处理 list 为 null 的情况
        return CHECKBOX_UNCHECKED;
    }
};

const toggleItemCheckbox = (item) => {
    item.selected = (item.selected === CHECKBOX_UNCHECKED ? CHECKBOX_CHECKED : CHECKBOX_UNCHECKED);
};

let _defaultSelectedData = [];


export default {
    name: 'x-multi-tree-select',
    mixins: [mixin],
    model: {
        event: Event_Select_Value
    },
    props: {
        inputContent:{
          type: Array,
          required: true,
        },
        value: {
            type: [Object, Array],
        },
        initData: {
            type: Object,
            required: true,
        },
        fields: {
            type: Array,
            required: true,
        },
        fieldTexts: {
            type: Array,
            required: true,
        },
        // 展示的数据层级，允许传入多级数据，通过此字段动态控制切换，以展示部分层级数据
        levelDepth: {
            type: Number,
            default: 0,
        },
        selectedDataType: {
            type: String,
            default: EVERY_LEVEL_INDEX
        },
        defaultSelectedDataType: {
            type: String,
            default: LAST_LEVEL
        },
        defaultSelectAll: {
            type: Boolean,
            default: false
        },
        allowSearch: {
            type: Boolean,
            default: true
        },
        allowClear: {
            type: Boolean,
            default: true
        },
        disabled: {
            type: Boolean,
            default: false
        },
        defaultSelectedData: {
            type: [Array, Object],
            default() {
                return []
            }
        },
        keyName: {
            type: String,
            default: 'key'
        },
        textName: {
            type: String,
            default: 'text'
        },
    },
    components: {
        vCheckbox,
    },
    data() {
        return {
            showDropDown: false,
            treeRoot: {
                // 原始数据
            },
            levelData: [// 用于 界面视图 展示的数据源
                // { key, list:[] }
            ],
            hasSelected: false,
            selectedTips: [],
        };
    },
    computed: {
        fieldsLen() {
            if (this.levelDepth > 0) {
                return Math.min(this.levelDepth, this.fields.length);
            } else {
                return this.fields.length;
            }
        },
        // 是否全选
        allSelected() {
            return !!this.treeRoot && this.treeRoot.selected === CHECKBOX_CHECKED;
        },

        // 是否`全没选`
        allNonSelected() {
            return !!this.treeRoot && this.treeRoot.selected === CHECKBOX_UNCHECKED;
        },
    },
    watch: {
        initData(val) {
            this.$emit('refresh');
        },
        fields() {
            this.$emit('refresh');
        },
        levelDepth() {
            this.$emit('refresh');
        },
        defaultSelectedData(val) {
            this.$emit('refresh');
        },
    },
    methods: {
        filterList(list, keyword) {
            return filterList(list, keyword, this.textName);
        },
        init(data) {
            if(this.defaultSelectedDataType === LAST_LEVEL) {
                if(this.defaultSelectedData instanceof Array)
                    _defaultSelectedData = this.defaultSelectedData.concat();// 拷贝一份用于`rawData2Tree`里逐个比对删除
                else
                    throw Error('当defaultSelectedDataType为LAST时，defaultSelectedData 必须为数组！');
            } else if(this.defaultSelectedDataType === EVERY_LEVEL_KEY  || this.defaultSelectedDataType === EVERY_LEVEL_INDEX){
                let keys = Object.keys(this.defaultSelectedData);
                for(let i = 0, len = keys.length; i < len; i++) {
                    _defaultSelectedData[keys[i]] = this.defaultSelectedData[keys[i]].concat();
                }
            }
            let tree = this.rawData2Tree(data);
            if (tree) {
                // treeRoot 是在原始数据之外增加的一层数据，需要单独处理 selected
                let treeRoot = {
                    [this.keyName]: 'root',
                    [this.textName]: 'root',
                    selected: compareWithSibling(tree),
                    hoverKey: '',
                    sugText: '',
                    branchDepth: 0,
                    list: tree,
                };

                let start = {
                    [this.keyName]: 'start',
                    selected: 0,
                    hoverKey: 'root',
                    list: {
                        'root': treeRoot,
                    }
                };
                travelDown(start, (item, subItem) => {
                    subItem.parent = item;// 给子节点追加 parent 属性，用于回溯
                    if(item.selected === CHECKBOX_CHECKED && !this.defaultSelectAll) {
                        subItem.selected = CHECKBOX_CHECKED;
                    }
                });
                this.treeRoot = treeRoot;
                this.levelData = [];
                this.$set(this.levelData, '0', start);
                this.hover(this.treeRoot, 0);// hover root node
                this.getSelected();
                // this.checkDefaultSelected();
            }
        },
        checkDefaultSelected() {
            if(this.defaultSelectAll) {
                this.selectAll();
                return;
            }
            if(this.defaultSelectedDataType === EVERY_LEVEL_INDEX) {
                let defaultData = {};
                const originDefaultData = this.defaultSelectedData;
                for(let i = 0, len = originDefaultData.length; i < len; i++) {
                    defaultData[this.fields[i]] = originDefaultData[i];
                }
                this.checkItemByLevel(defaultData);
            } else if(this.defaultSelectedDataType === EVERY_LEVEL_KEY) {
                this.checkItemByLevel(this.defaultSelectedData);
            }
        },
        getDefaultSelected(key, branchDepth, list) {
            switch(this.defaultSelectedDataType) {
                case LAST_LEVEL:
                    if(branchDepth !== this.fieldsLen -1 ){
                        return compareWithSibling(list);
                    }
                    const lastIndex = _defaultSelectedData.indexOf(key);
                    if (lastIndex > -1) {
                        _defaultSelectedData.splice(lastIndex, 1);
                        return CHECKBOX_CHECKED;
                    }
                    return CHECKBOX_UNCHECKED;
                case EVERY_LEVEL_INDEX:
                    const indexBranchList = _defaultSelectedData[branchDepth] || [];
                    const index = indexBranchList.indexOf(key);
                    if(index > -1) {
                        _defaultSelectedData[branchDepth].splice(index, 1);
                        return CHECKBOX_CHECKED;
                    }
                    return compareWithSibling(list);
                case EVERY_LEVEL_KEY:
                    const branchList = _defaultSelectedData[this.fields[branchDepth]] || [];
                    const keyIndex = branchList.indexOf(key);
                    if(keyIndex > -1) {
                        branchList.splice(keyIndex, 1);
                        return CHECKBOX_CHECKED;
                    }
                    return compareWithSibling(list);
            }
        },
        /**
         * 把原始数据转换成树
         */
        rawData2Tree(rawData, branchDepth = 0) {
            if (rawData && branchDepth < this.fieldsLen) {
                let list = rawData[this.fields[branchDepth]];
                if (list) {
                    let keyName = this.keyName;
                    let textName = this.textName;
                    let tree = {};
                    for(let index = 0, len = list.length; index < len; index++) {
                        const item = list[index];
                        var _list = this.rawData2Tree(item, branchDepth + 1);
                        tree[item[keyName]] = {
                            [keyName]: item[keyName],
                            [textName]: item[textName],
                            "order": index,
                            "sugText": '',
                            "hoverKey": '',
                            // 如果是最后一级树枝，则设置默认值； 如果不是，则其值通过其下级比对得到
                            // 0: 未选, 1: 勾选, 2: 子集有部分
                            "selected": this.defaultSelectAll ? CHECKBOX_CHECKED : this.getDefaultSelected(item[keyName], branchDepth, _list) ,
                            "branchDepth": branchDepth + 1,
                            "list": _list
                        };
                    }
                    return tree;
                }
            }
            return null;
        },
        /**
         * 鼠标 hover 触发的事件
         */
        hover(item, levelIndex) {
            let level = this.levelData[levelIndex];
            if (level.hoverKey !== '') {// 清除上一个 hover 的子列表 sug
                let oldHoverItem = level.list[level.hoverKey];
                oldHoverItem && (oldHoverItem.sugText = '');
            }
            level.hoverKey = item[this.keyName];
            this.buildLeveData(item, levelIndex + 1);
        },
        // hover 全部
        hoverForAll(level, levelIndex) {
            level.hoverKey = 'all';
            // 如果前一列已经 hover 到了`全部`上,则不再展开下级
            if (this.prevLevelIsHoverAll(levelIndex) && levelIndex !== 2) return;
            let nextLevelIndex = levelIndex + 1;
            this.buildLeveData({
                [this.keyName]: 'all',
                hoverKey: '',
                sugText: '',
                selected: level.selected,
                branchDepth: level.branchDepth + 1,
                list: concatMultiList(level.list), // 合并树枝
                virtualItem: true, // 原始的树上并没有这个节点的位置，而是针对视图捏造的一个节点
            }, nextLevelIndex);
        },
        /**
         * 组装 View 层 展示数据
         */
        buildLeveData(item, levelIndex) {
            if (levelIndex <= this.fieldsLen) { // 边界：最后一列 hover，不再展现子列
                if (!this.levelData[levelIndex] || this.levelData[levelIndex][this.keyName] !== item[this.keyName]) {
                    this.$set(this.levelData, levelIndex, item);
                }
                this.levelData.splice(levelIndex + 1);// 始终只显示下一集目录，多余的 cut
            }
        },
        clearSug(level) {
            if (level && level.sugText !== '') {
                level.sugText = '';
            }
        },

        // 勾选`普通项`
        checkItem(level, item, levelIndex, selectStatus) {
            if (selectStatus !== undefined) {
                item.selected = selectStatus;
            } else {
                toggleItemCheckbox(item);
            }
            // check item 后，该 item.selected 并不会立即变化，会导致 compareWithSibling 计算错误，
            // 所以借助 $nextTick
            this.$nextTick(() => {
                this.travelUpView(levelIndex - 1);
            });
            travelUp(item, (parent) => {
                parent.selected = compareWithSibling(parent.list);
            }, this.keyName);
            travelDown(item, (_item, subItem) => {
                subItem.selected = _item.selected;
            });
            this.getSelected();
        },
        travelUpView(levelIndex) {
            while (levelIndex > 1) {
                let level = this.levelData[levelIndex];
                if (level && level.virtualItem) {
                    this.$set(this.levelData[levelIndex], 'selected', compareWithSibling(level.list));
                }
                levelIndex--;
            }
        },
        // 勾选`全选`
        checkItemAll(level, item, levelIndex, selectStatus) {
            let prevLevel = this.levelData[levelIndex - 1];
            if (prevLevel.hoverKey === 'all') { // 当前列的上一列已 hover `全选`
                if (selectStatus !== undefined) {
                    item.selected = selectStatus;
                } else {
                    toggleItemCheckbox(item);
                }
                this.checkItemAll(prevLevel, prevLevel, levelIndex - 1, item.selected);
            }
            else { // 当前列的上一列 hover 的是普通项
                // 全选项是上一列的普通项
                this.checkItem(prevLevel, item, levelIndex - 1, selectStatus);
            }
            // 当前不是最后一列，则需要更新下一列的`全选`勾选状态
            if (levelIndex < this.fieldsLen) {
                let nextLevel = this.levelData[levelIndex + 1];
                nextLevel && (nextLevel.selected = item.selected);
            }
        },

        // 当前列展示的是`全部`时，且没有 sug 条件时，不渲染列表
        showListView(level) {
            let key = level[this.keyName];
            let sugText = level.sugText;
            if (key === 'all' && sugText === '') {
                return false;
            }
            return true;
        },
        // 递归遍历各选中节点
        collectSelected(list, ret, leafs) {
            if (list) {
                const keys = Object.keys(list);
                for(let j = 0, len = keys.length; j < len; j++) {
                    let item = list[keys[j]];
                    if (item.selected !== CHECKBOX_UNCHECKED) {// 只遍历 1 、 2
                        if (item.selected === CHECKBOX_CHECKED) {
                            ret[item.branchDepth]++;
                            if (item.branchDepth === this.fieldsLen) {// 收集末端节点
                                leafs.push(item[this.keyName]);
                            }
                        }
                        item.list && this.collectSelected(item.list, ret, leafs);
                    }
                }
            }
        },
        recurCallSelected(levelData, levelSelectedData, tips, leafs) {
            const keys = Object.keys(levelData);
            for(let i = 0, len = keys.length; i < len; i++) {
                let item = levelData[keys[i]];
                if(item.branchDepth === 0) {
                    item.list && this.recurCallSelected(item.list, levelSelectedData, tips, leafs);
                }
                if (item.selected === CHECKBOX_CHECKED) {
                    levelSelectedData && levelSelectedData[item.branchDepth-1].push(item[this.keyName]);

                    tips[item.branchDepth]++;
                    if (item.branchDepth === this.fieldsLen) {// 收集末端节点
                        leafs.push(item[this.keyName]);
                    }
                    item.list && this.recurCallSelected(item.list, null, tips, leafs);
                } else if (item.selected === CHECKBOX_INDETERMINATE) {
                    item.list && this.recurCallSelected(item.list, levelSelectedData, tips, leafs);
                }
            }
        },
        getLevelSelected() { // type 可选{INDEX, KEY}
            const me = this;
            let levelSelectedData = [];
            let leafs = [];
            let tips = [
                0
                // 1:0,
                // 2:0,
                // 3:0,
            ];
            let levelData = this.levelData[1] && this.levelData[1].list;
            for (let i = 0, len = this.fieldsLen; i < len; i++) {
                tips[i+1] = 0;
                levelSelectedData[i] = [];
            }
            levelData && this.recurCallSelected(levelData, levelSelectedData, tips, leafs);
            return {levelSelectedData, leafs, tips};
        },
        getKeyLevelSelected(levelArr) {
            let levelDataMap = {};
            levelArr.map((level, index) => {
                levelDataMap[this.fields[index]] = level;
            });
            return levelDataMap;
        },
        // 清空按钮
        clearAll() {
            this.checkItem(this.treeRoot, this.treeRoot, 0, CHECKBOX_UNCHECKED);
            this.showDropDown = false;
        },
        prevLevelIsHoverAll(levelIndex) {
            let prevLevel = this.levelData[levelIndex - 1];
            return prevLevel && (prevLevel.hoverKey === 'all');
        },
        // 是否隐藏列表项的下钻小箭头
        hideSubListArrow(levelIndex) {
            if (levelIndex == this.fieldsLen // 最后一列
                || levelIndex > 2 && this.prevLevelIsHoverAll(levelIndex)
            ) {
                return true;
            }
        },
        // 向外通过事件暴露选择结果
        getSelected() {
            exposeDataEventTimer || clearTimeout(exposeDataEventTimer);
            // debounce: 避免由于多个 props 改变，触发 refresh 后向外频繁抛出事件
            exposeDataEventTimer = setTimeout(() => {
                const {levelSelectedData , leafs, tips} = this.getLevelSelected();
                this.selectedTips = tips;
                this.hasSelected = leafs.length > 0;
                const allSelectedItems = {
                    selected: leafs, // 已选的根节点 key
                    indexSelected: levelSelectedData, // 每一级的已选数据
                    isAllSelected: this.allSelected, // 是否全选
                    isAllNoneSelected: this.allNonSelected, // 是否全不选
                };
                this.$emit(Event_Select_With_Path, allSelectedItems);
                switch(this.selectedDataType) {
                    case EVERY_LEVEL_INDEX:
                        this.$emit(Event_Select_Value, levelSelectedData); break;
                    case EVERY_LEVEL_KEY:
                        this.$emit(Event_Select_Value, this.getKeyLevelSelected(levelSelectedData)); break;
                    case LAST_LEVEL:
                        this.$emit(Event_Select_Value, leafs); break;
                    case ALL_LEVEL:
                        this.$emit(Event_Select_Value, allSelectedItems); break;
                }
            }, 0);
        },
        // 对外公布的方法，用于从外部操作，勾选全部
        selectAll() {
            this.checkItem(this.levelData[0], this.treeRoot, 1, CHECKBOX_CHECKED);
        },
        checkItemByLevel(levelObj, maxDepth = 6, selectStatus = CHECKBOX_CHECKED) {// {city_list:  [cityid...]}
            let fields = this.fields;
            travelDown(this.treeRoot, (item, subItem) => {
                if (subItem.branchDepth > +maxDepth) {
                    return true
                }
                let levelIds = subItem.branchDepth > 0 ? levelObj[fields[subItem.branchDepth - 1]] : false;
                if (levelIds) {
                    if (~levelIds.indexOf(subItem[this.keyName])) {
                        this.checkItem(null, subItem, subItem.branchDepth, selectStatus);
                        return true;
                    }
                }
                return false;
            })
        },
    },
    mounted() {
        let refreshTimer = null;
        this.$on('refresh', () => {
            clearTimeout(refreshTimer);
            // 避免由于多个 props 改变，触发频繁初始化数据
            refreshTimer = setTimeout(() => {
                this.init(this.initData);
                this.$emit(Event_INITED)
            }, 0);
        });
        this.init(this.initData);
    }
}
</script>
<style scoped>
@charset "UTF-8";
@font-face {font-family: "iconfont";
  src: url('../../../assets/iconfont/iconfont.eot?t=1566532542787'); /* IE9 */
  src: url('../../../assets/iconfont/iconfont.eot?t=1566532542787#iefix') format('embedded-opentype'), /* IE6-IE8 */
  url('../../../assets/iconfont/iconfont.woff?t=1566532542787') format('woff'),
  url('../../../assets/iconfont/iconfont.ttf?t=1566532542787') format('truetype'), /* chrome, firefox, opera, Safari, Android, iOS 4.2+ */
  url('../../../assets/iconfont/iconfont.svg?t=1566532542787#iconfont') format('svg'); /* iOS 4.1- */
}
.x-tree-select-input-content {
    width: 150px !important;
    overflow: hidden;
    /*文本不会换行*/
    white-space: nowrap;
    /*当文本溢出包含元素时，以省略号表示超出的文本*/
    text-overflow: ellipsis;
}
.input-group-error-prepend,
.input-group-error-append {
  background-color: #fff;
  border: 1px solid #F04134;
}
.input-group-error-prepend .x-select-selection,
.input-group-error-append .x-select-selection {
  background-color: inherit;
  border: 1px solid transparent;
}
.input-group-error-prepend {
  border-right: 0;
}
.input-group-error-append {
  border-left: 0;
}
.x-input {
  display: inline-block;
  width: 100%;
  height: 34px;
  padding: 6px 12px;
  font-size: 14px;
  line-height: 1.42857143;
  color: #555555;
  background-color: #fff;
  background-image: none;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
  box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
  -webkit-transition: border-color ease-in-out .3s, box-shadow ease-in-out .3s;
  -o-transition: border-color ease-in-out .3s, box-shadow ease-in-out .3s;
  transition: border-color ease-in-out .3s, box-shadow ease-in-out .3s;
}
.x-input:hover {
  border-color: #2d8cf0;
}
.x-input:focus {
  border-color: #2d8cf0;
  outline: 0;
  box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 8px #2d8cf0;
}
.x-input::-moz-placeholder {
  color: #ccc;
  opacity: 1;
}
.x-input:-ms-input-placeholder {
  color: #ccc;
}
.x-input::-webkit-input-placeholder {
  color: #ccc;
}
.x-input::-ms-expand {
  border: 0;
  background-color: transparent;
}
.x-input[disabled],
.x-input[readonly],
fieldset[disabled] .x-input {
  background-color: #f7f7f7;
  opacity: 1;
}
.x-input[disabled],
fieldset[disabled] .x-input {
  background-color: #f7f7f7;
  opacity: 1;
  cursor: not-allowed;
  color: rgba(0, 0, 0, 0.25);
}
.x-input[disabled]:hover,
fieldset[disabled] .x-input:hover {
  border-color: #d6d6d6;
}
.x-input-large {
  font-size: 16px;
  padding: 8px 14px;
  height: 40px;
}
.x-input-small {
  font-size: 12px;
  padding: 5px 10px;
  height: 30px;
}
textarea.x-input {
  max-width: 100%;
  height: auto;
  vertical-align: bottom;
  font-size: 14px;
}
.x-input-wrap {
  display: inline-block;
  width: 100%;
  position: relative;
  vertical-align: middle;
}
.x-input-wrap.is-disabled > .x-input-icon:hover {
  color: #bfbfbf;
  cursor: not-allowed;
}
.x-input-wrap .max-text {
  position: absolute;
  right: 0;
  display: block;
  padding: 3px 0;
  font-size: 12px;
}
.x-input-wrap .max-text.max-reached {
  color: #F04134;
}
.x-input-icon {
  width: 34px;
  height: 34px;
  line-height: 34px;
  font-size: 17px;
  text-align: center;
  position: absolute;
  right: 0;
  z-index: 1;
  color: #bfbfbf;
}
.x-input-icon:hover {
  color: #a6a6a6;
  cursor: pointer;
}
.x-input-icon + .x-input {
  padding-right: 32px;
}
.x-input-wrap-large .x-input-icon {
  width: 40px;
  font-size: 20px;
  height: 40px;
  line-height: 40px;
}
.x-input-wrap-small .x-input-icon {
  width: 30px;
  font-size: 15px;
  height: 30px;
  line-height: 30px;
}
.x-input-wrap-small .x-input-icon + .x-input {
  padding-right: 24px;
}
.x-input-group {
  display: table;
  width: 100%;
  border-collapse: separate;
  position: relative;
  font-size: 14px;
}
.x-input-group-large {
  font-size: 16px;
}
.x-input-group[class*="col-"] {
  float: none;
  padding-left: 0;
  padding-right: 0;
}
.x-input-group > [class*="col-"] {
  padding-right: 8px;
}
.x-input-group-prepend,
.x-input-group-append,
.x-input-group > .x-input {
  display: table-cell;
}
.x-input-group-prepend:not(:first-child):not(:last-child),
.x-input-group-append:not(:first-child):not(:last-child),
.x-input-group > .x-input:not(:first-child):not(:last-child) {
  border-radius: 0;
}
.x-input-group-prepend .x-btn,
.x-input-group-append .x-btn {
  border-color: transparent;
  background-color: transparent;
  color: inherit;
  margin: -7px -12px;
}
.x-input-group-prepend,
.x-input-group-append {
  width: 1px;
  white-space: nowrap;
  vertical-align: middle;
}
.x-input-group .x-input {
  width: 100%;
  float: left;
  margin-bottom: 0;
  position: relative;
  z-index: 2;
}
.x-input-group-prepend,
.x-input-group-append {
  padding: 6px 12px;
  font-size: inherit;
  font-weight: normal;
  line-height: 1;
  color: #555555;
  text-align: center;
  background-color: #eee;
  border: 1px solid #ccc;
  border-radius: 4px;
}
.x-input-group-prepend .x-select,
.x-input-group-append .x-select {
  margin: -7px -12px;
}
.x-input-group-prepend .x-select .x-input,
.x-input-group-append .x-select .x-input {
  background: transparent !important;
  border: 0;
  border-top-right-radius: 0;
  border-bottom-right-radius: 0;
}
.x-input-group-prepend .x-select-selection,
.x-input-group-append .x-select-selection {
  background-color: inherit;
  margin: -1px;
  border: 1px solid transparent;
}
.x-input-group-prepend .x-select-visible .x-select-selection,
.x-input-group-append .x-select-visible .x-select-selection {
  box-shadow: none;
}
.x-input-group > span > .x-input:first-child,
.x-input-group > .x-input:first-child,
.x-input-group-prepend {
  border-bottom-right-radius: 0 !important;
  border-top-right-radius: 0 !important;
}
.x-input-group > span > .x-input:first-child .x-select .x-select-selection,
.x-input-group > .x-input:first-child .x-select .x-select-selection,
.x-input-group-prepend .x-select .x-select-selection {
  border-bottom-right-radius: 0;
  border-top-right-radius: 0;
}
.x-input-group-prepend {
  border-right: 0;
}
.x-input-group-append {
  border-left: 0;
}
.x-input-group > .x-input:last-child,
.x-input-group-append {
  border-bottom-left-radius: 0 !important;
  border-top-left-radius: 0 !important;
}
.x-input-group > .x-input:last-child .x-select .x-select-selection,
.x-input-group-append .x-select .x-select-selection {
  border-bottom-left-radius: 0;
  border-top-left-radius: 0;
}
.x-input-group-large .x-input,
.x-input-group-large > .x-input-group-prepend,
.x-input-group-large > .x-input-group-append {
  font-size: 16px;
  padding: 8px 14px;
  height: 40px;
}
.x-input-group-small .x-input,
.x-input-group-small > .x-input-group-prepend,
.x-input-group-small > .x-input-group-append {
  font-size: 12px;
  padding: 5px 10px;
  height: 30px;
}
.x-form-item-error .x-input {
  border: 1px solid #F04134;
}
.x-form-item-error .x-input:hover {
  border-color: #F04134;
}
.x-form-item-error .x-input:focus {
  border-color: #F04134;
  outline: 0;
  box-shadow: 0 0 0 2px rgba(240, 65, 52, 0.2);
}
.x-form-item-error .x-input-icon {
  color: #F04134;
}
.x-form-item-error .x-input-group-prepend,
.x-form-item-error .x-input-group-append {
  background-color: #fff;
  border: 1px solid #F04134;
}
.x-form-item-error .x-input-group-prepend .x-select-selection,
.x-form-item-error .x-input-group-append .x-select-selection {
  background-color: inherit;
  border: 1px solid transparent;
}
.x-form-item-error .x-input-group-prepend {
  border-right: 0;
}
.x-form-item-error .x-input-group-append {
  border-left: 0;
}
.x-form-item-validating .x-input-icon-validate {
  display: inline-block;
}

.x-tree-select {
  display: inline-block;
  vertical-align: middle;
}
.x-tree-select-input {
  display: inline-block;
  width: 100%;
  height: 34px;
  padding: 6px 12px;
  font-size: 14px;
  line-height: 1.42857143;
  color: #555555;
  background-color: #fff;
  background-image: none;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
  box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
  -webkit-transition: border-color ease-in-out .3s, box-shadow ease-in-out .3s;
  -o-transition: border-color ease-in-out .3s, box-shadow ease-in-out .3s;
  transition: border-color ease-in-out .3s, box-shadow ease-in-out .3s;
}
.x-tree-select-input:hover {
  border-color: #2d8cf0;
}
.x-tree-select-input:focus {
  border-color: #2d8cf0;
  outline: 0;
  box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 8px #2d8cf0;
}
.x-tree-select-input::-moz-placeholder {
  color: #ccc;
  opacity: 1;
}
.x-tree-select-input:-ms-input-placeholder {
  color: #ccc;
}
.x-tree-select-input::-webkit-input-placeholder {
  color: #ccc;
}
.x-tree-select-input::-ms-expand {
  border: 0;
  background-color: transparent;
}
.x-tree-select-input[disabled],
.x-tree-select-input[readonly],
fieldset[disabled] .x-tree-select-input {
  background-color: #f7f7f7;
  opacity: 1;
}
.x-tree-select-input[disabled],
fieldset[disabled] .x-tree-select-input {
  background-color: #f7f7f7;
  opacity: 1;
  cursor: not-allowed;
  color: rgba(0, 0, 0, 0.25);
}
.x-tree-select-input[disabled]:hover,
fieldset[disabled] .x-tree-select-input:hover {
  border-color: #d6d6d6;
}
.x-tree-select-input-large {
  font-size: 16px;
  padding: 8px 14px;
  height: 40px;
}
.x-tree-select-input-small {
  font-size: 12px;
  padding: 5px 10px;
  height: 30px;
}
textarea.x-tree-select-input {
  max-width: 100%;
  height: auto;
  vertical-align: bottom;
  font-size: 14px;
}
.x-tree-select-input .no-select {
  color: #cccccc;
}
.x-tree-select-input.is-disabled {
  background-color: #f7f7f7;
  opacity: 1;
  cursor: not-allowed;
  color: rgba(0, 0, 0, 0.25);
}
.x-tree-select-input:hover {
  cursor: pointer;
}
.x-tree-select-input-count {
  color: #2d8cf0;
}
.x-tree-select-input-count + .x-tree-select-input-count {
  margin-left: 3px;
}
.x-tree-select-input-wrap {
  width: 150px;
  position: relative;
  display: block;
}
.x-tree-select-input-icon + .x-tree-select-input {
  padding-right: 32px;
}
.x-tree-select-input-icon {
  width: 34px;
  height: 34px;
  line-height: 34px;
  font-size: 17px;
  text-align: center;
  position: absolute;
  right: 0;
  top: 0;
  z-index: 1;
  color: #bfbfbf;
}
.x-tree-select-input-icon:hover {
  color: #a6a6a6;
  cursor: pointer;
}
.x-tree-select-item-wrap {
  position: absolute;
  box-shadow: 0 1px 6px rgba(0, 0, 0, 0.2);
  border: 1px solid #d9d9d9;
  border-radius: 2px;
  background-color: #fff;
  z-index: 999;
  margin: 5px 0;
}
.x-tree-select-item {
  border-left: 1px solid #d9d9d9;
  margin-left: -1px;
  display: inline-block;
  float: left;
  max-height: 300px;
  overflow-y: auto;
}
.x-tree-select-item-level {
  overflow: hidden;
  display: flex;
}
.x-tree-select-item:nth-child(1) {
  display: none;
}
.x-tree-select-item ul {
  margin: 0;
  padding: 0px;
}
.x-tree-select-item ul .x-tree-select-item-search {
  list-style: none;
  cursor: pointer;
  padding: 10px;
  margin-bottom: 0;
  display: flex;
  width: 150px;
}
.x-tree-select-item ul .x-tree-select-item-search.active {
  background: #f0fafa;
}
.x-tree-select-item ul .x-tree-select-item-search.checkbox-all {
  font-weight: bold;
}
.x-tree-select-item ul .x-tree-select-item-li {
  list-style: none;
  cursor: pointer;
  padding: 0 10px;
  margin-bottom: 0;
  display: flex;
  width: 150px;
}
.x-tree-select-item ul .x-tree-select-item-li.active {
  color: #2d8cf0;
  background: #f0fafa;
  font-weight: 500;
}
.x-tree-select-item ul .x-tree-select-item-li.checkbox-all {
  font-weight: bold;
}
.x-tree-select-item-search {
  position: relative;
  padding: 0 0 3px;
}
.x-tree-select-item-input {
  display: inline-block;
  width: 100%;
  height: 34px;
  padding: 6px 12px;
  font-size: 14px;
  line-height: 1.42857143;
  color: #555555;
  background-color: #fff;
  background-image: none;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
  box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
  -webkit-transition: border-color ease-in-out .3s, box-shadow ease-in-out .3s;
  -o-transition: border-color ease-in-out .3s, box-shadow ease-in-out .3s;
  transition: border-color ease-in-out .3s, box-shadow ease-in-out .3s;
  font-size: 12px;
  padding: 5px 10px;
  height: 30px;
}
.x-tree-select-item-input:hover {
  border-color: #2d8cf0;
}
.x-tree-select-item-input:focus {
  border-color: #2d8cf0;
  outline: 0;
  box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075), 0 0 8px #2d8cf0;
}
.x-tree-select-item-input::-moz-placeholder {
  color: #ccc;
  opacity: 1;
}
.x-tree-select-item-input:-ms-input-placeholder {
  color: #ccc;
}
.x-tree-select-item-input::-webkit-input-placeholder {
  color: #ccc;
}
.x-tree-select-item-input::-ms-expand {
  border: 0;
  background-color: transparent;
}
.x-tree-select-item-input[disabled],
.x-tree-select-item-input[readonly],
fieldset[disabled] .x-tree-select-item-input {
  background-color: #f7f7f7;
  opacity: 1;
}
.x-tree-select-item-input[disabled],
fieldset[disabled] .x-tree-select-item-input {
  background-color: #f7f7f7;
  opacity: 1;
  cursor: not-allowed;
  color: rgba(0, 0, 0, 0.25);
}
.x-tree-select-item-input[disabled]:hover,
fieldset[disabled] .x-tree-select-item-input:hover {
  border-color: #d6d6d6;
}
.x-tree-select-item-input-large {
  font-size: 16px;
  padding: 8px 14px;
  height: 40px;
}
.x-tree-select-item-input-small {
  font-size: 12px;
  padding: 5px 10px;
  height: 30px;
}
textarea.x-tree-select-item-input {
  max-width: 100%;
  height: auto;
  vertical-align: bottom;
  font-size: 14px;
}
.x-tree-select-item-input-icon {
  height: 30px;
  width: 30px;
  font-size: 15px;
  top: 12px;
  right: 10px;
  line-height: 30px;
}
.x-tree-select-checkbox.x-checkbox .x-checkbox-item {
  height: 36px;
  line-height: 36px;
}
.x-tree-select-checkbox.x-checkbox .x-checkbox-item * {
  height: 16px;
  width: 16px;
}
.x-tree-select-checkbox.x-checkbox .x-checkbox-item .x-checkbox-background {
  transition: none;
  animation: initial;
}
.x-tree-select-checkbox.x-checkbox .x-checkbox-item .x-checkbox-cbx {
  transition: none;
  animation: initial;
}
.x-tree-select-checkbox.x-checkbox .x-checkbox-item.is-checked .x-checkbox-background,
.x-tree-select-checkbox.x-checkbox .x-checkbox-item.is-indeterminate .x-checkbox-background {
  transition: none;
  animation: initial;
}
.x-tree-select-checkbox.x-checkbox .x-checkbox-item.is-checked .x-checkbox-cbx,
.x-tree-select-checkbox.x-checkbox .x-checkbox-item.is-indeterminate .x-checkbox-cbx {
  transition: none;
  animation: initial;
  height: 5px;
  width: 10px;
  left: 3px;
}
.x-tree-select-right-icon {
  line-height: 36px;
  margin-left: 4px;
}
.x-icon {
  font-family: "iconfont" !important;
  font-size: 16px;
  font-style: normal;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.x-icon-chevron-right:before {
  content: "\e770";
}


/* .x-icon-chevron-right:before {
    content: "\e770";
} */

/*# sourceMappingURL=./tree-select.css.map */
</style>
