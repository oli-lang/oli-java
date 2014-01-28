/*
 * This file is part of antlr-java-parser.
 *
 *     antlr-java-parser is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     antlr-java-parser is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with antlr-java-parser.  If not, see <http://www.gnu.org/licenses/>.
 */

package com.github.antlrjavaparser.adapter;

import com.github.antlrjavaparser.Java7Parser;
import com.github.antlrjavaparser.api.body.Parameter;

import java.util.LinkedList;
import java.util.List;

public class FormalParameterDeclsContextAdapter implements Adapter<List<Parameter>, Java7Parser.FormalParameterDeclsContext> {
    public List<Parameter> adapt(Java7Parser.FormalParameterDeclsContext context, AdapterParameters adapterParameters) {

        /*
        formalParameterDecls
        locals [int parameterType]
            :   ellipsisParameterDecl                               {$parameterType = 1;}
            |   normalParameterDecl (COMMA normalParameterDecl)*    {$parameterType = 2;}
            |   (normalParameterDecl COMMA)+ ellipsisParameterDecl  {$parameterType = 3;}
            ;
         */
        List<Parameter> parameterList = new LinkedList<Parameter>();

        if (context.normalParameterDecl() != null && context.normalParameterDecl().size() > 0) {
            for (Java7Parser.NormalParameterDeclContext normalParameterDeclContext : context.normalParameterDecl()) {
                parameterList.add(Adapters.getNormalParameterDeclContextAdapter().adapt(normalParameterDeclContext, adapterParameters));
            }
        }

        if (context.ellipsisParameterDecl() != null) {
            parameterList.add(Adapters.getEllipsisParameterDeclContextAdapter().adapt(context.ellipsisParameterDecl(), adapterParameters));
        }

        return parameterList;
    }
}
